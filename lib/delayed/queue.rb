module Delayed
  module Backend
    module ActiveRecord
      class Queue < ::ActiveRecord::Base
        has_many :jobs
      end
    end
  end
end