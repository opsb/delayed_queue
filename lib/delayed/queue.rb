module Delayed
  class Queue < ActiveRecord::Base
    has_many :jobs
  end
end