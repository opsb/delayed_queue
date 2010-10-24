require 'spec/spec_helper'

describe Delayed::Backend::ActiveRecord::Job do
  before do
    @job = SimpleJob.new 
  end

  context "that has been added to a queue" do
    before do
      queue = Delayed::Backend::ActiveRecord::Queue.new
      queue << @job 
    end

    it "is available in global queue" do
      Delayed::Job.find_available(nil, 1).first.payload_object.should == @job
    end
  end 
end
