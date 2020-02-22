module Integral
  # All jobs inherit this behaviour
  class ApplicationJob < ActiveJob::Base
    queue_as :default
    # Automatically retry jobs that encountered a deadlock
    # retry_on ActiveRecord::Deadlocked

    # Most jobs are safe to ignore if the underlying records are no longer available
    # discard_on ActiveJob::DeserializationError
  end
end
