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
        scope :ready_to_run, lambda {|*args|
          orig_ready_to_run(*args).
          joins(:queue).
          where(["delayed_jobs.attempts > 0 or queues.locked = ?", false])
        }
      end
    end
  end
end

