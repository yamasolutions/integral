require 'open-uri'

namespace :integral do
  namespace :datafixes do
    desc 'Converts Ckeditor assets to Integral images avatar assets to AS'
    task :convert_ckeditor_assets_to_integral_images, [:amount] => [:environment] do |_t, args|
      puts 'Converting Ckeditor Assets to Integral Images'
      convert_ckeditor_assets_to_integral_images(Ckeditor::Asset, :data)
    end

    def convert_ckeditor_assets_to_integral_images(klass, uploader)
      carry_out_tasks klass, {} do |asset|
        file_name = File.basename(asset.data_file_name, File.extname(asset.data_file_name))
        title = "#{file_name}-CKCOPY#{asset.id}"

        if Integral::Image.exists?(title: title)
          puts 'Image already converted.'
        else
          Integral::Image.create(
            title: title,
            file: open(asset.send(uploader).url)
          )
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
  end
end
