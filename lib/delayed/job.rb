require 'delayed_job'

module Delayed
  module Backend
    module ActiveRecord
      class Job < ::ActiveRecord::Base
        belongs_to :queue
        scope :in_unlocked_queue, lambda {
          joins(:queue) & Queue.unlocked
        }
        scope :orig_ready_to_run, scopes[:ready_to_run]
        scope :ready_to_run, lambda {|worker_name, max_run_time|
          orig_ready_to_run(worker_name, max_run_time).in_unlocked_queue
        }
      end
    end
  end
end

