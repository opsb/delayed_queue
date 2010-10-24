module Delayed
  module Backend
    module ActiveRecord
      class Queue < ::ActiveRecord::Base
        has_many :jobs
        scope :unlocked, lambda {
          where(:locked => false)
        }
        def <<(job)
          jobs << (Job.enqueue job)
        end
        def lock
          self.locked = true
        end
        def unlock
          self.locked = false
        end
      end
    end
  end
end
