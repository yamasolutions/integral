namespace :integral do
  namespace :migrate do
    desc "Converts all user avatars to active storage"
    task convert_avatars_to_as: [:environment] do
      convert_uploaders_to_attachments(Integral::User, :avatar, :image)
    end

    desc "Converts all Integral Images to Integral Files"
    task convert_images_to_files: [:environment] do
      carry_out_tasks Integral::Image, {} do |asset|
        Integral::Storage::File.create!(
          id: asset.id,
          title: asset.title,
          description: asset.description
        )
      end
    end
  end
end

require 'open-uri'

def convert_uploaders_to_attachments(klass, uploader, attachment)
  carry_out_tasks klass, {} do |asset|
    if asset.send(uploader).present? && !asset.send(attachment).attached?
      asset.send(attachment).attach(io: open(asset.send(uploader).url), filename: asset.send(uploader).file.path.split("/").last)
      puts "AS attachment created for #{klass}##{asset.id}"
    end
  end
end

# Carries out tasks on provided objects. Gathers the object through arguments passed in
# Lists any errors which occur when carrying out the tasks
#
# @param klass [Class] class where the objects will be selected
# @param opts [Hash] options used to select the specific records
# Options parameters:
#   start - Single integer means start at specific ID, multiple integers means exclusive set
#   finish - End at specific record in database
#
#   Examples
#   start = "" end = "" - This will get all objects
#   start = "4", end = "" - This will get all objects starting from ID 4
#   start = "4", end = "9" - This will get all objects between ID 4 and 9 (inclusive)
#   start = "4 43 1 84" - This will get those specific objects
def carry_out_tasks(klass, opts, &block)
  errorous_ids = []

  gather_objects(klass, opts).each do |object|
    begin
      yield(object)
    rescue => e
      puts "Error manipulating ID: #{object.id}"
      puts e.message
      errorous_ids << [object.id, e.message]
    end
  end

  puts '----------------------------'
  puts 'Finished.'
  puts "Tasks carried out: #{gather_objects(klass, opts).count}"
  puts "Tasks failed: #{errorous_ids.count}"

  if errorous_ids.present?
    puts "Erroneous IDs: #{errorous_ids.map { |error| error.first }}"
    # puts "--------- Error Log ----------"
    # errorous_ids.each do |error|
    #   puts "ID: #{error.first} - #{error.second}"
    # end
  end
  puts '----------------------------'
end

# @return [Array] array of objects to iterate over
def gather_objects(klass, opts)
  # All records from the class
  return klass.all if opts[:start].nil?

  split_ids = opts[:start].split()

  # Exclusive set of records from the class
  return klass.find(split_ids) if split_ids.size > 1

  # All records from class starting specific ID
  return klass.where(:id => split_ids.first.to_i..klass.count) if opts[:finish].nil?

  # Range of records
  klass.where(:id => split_ids.first.to_i..opts[:finish].to_i)
end
