module Delayed
  module Backend
    module ActiveRecord
      class Queue < ::ActiveRecord::Base
        has_many :jobs
        def <<(job)
          jobs << (Job.enqueue job)
        end
      end
    end
  end
end
