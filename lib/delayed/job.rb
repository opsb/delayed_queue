require 'delayed_job'

module Delayed
  module Backend
    module ActiveRecord
      class Job < ::ActiveRecord::Base
        belongs_to :queue
        scope :in_unlocked_queue, lambda {
          joins(:queue) & Queue.unlocked
        }
        scope :ready_to_run, lambda {|worker_name, max_run_time|
          where(['(run_at <= ? AND (locked_at IS NULL OR locked_at < ?) OR locked_by = ?) AND failed_at IS NULL', db_time_now, db_time_now - max_run_time, worker_name]).
          in_unlocked_queue
        }
      end
    end
  end
end

