module Delayed
  module Backend
    module ActiveRecord
      class Queue < ::ActiveRecord::Base
        set_table_name "delayed_queues"
        has_many :jobs

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
