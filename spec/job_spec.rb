require 'spec/spec_helper'

describe Delayed::Backend::ActiveRecord::Job do
  it { should belong_to(:queue) }
  before do
    @job = SimpleJob.new 
  end

  context "that has been added to a queue" do
    before do
      queue = Delayed::Backend::ActiveRecord::Queue.create
      queue << @job 
    end

    it "is available in global queue" do
      Delayed::Job.find_available(nil, 1).first.payload_object.should == @job
    end
  end 

  context "that has been added to a locked queue" do
    before do
      queue = Delayed::Backend::ActiveRecord::Queue.create
      queue.lock
      queue.save
      queue << @job 
    end
    it "is not included in unlocked queues" do
      Queue.unlocked.each{|q| puts q.locked}
      Delayed::Job.in_unlocked_queue.should be_empty
    end
    it "is not ready to run" do
      Delayed::Job.ready_to_run(nil, 1).should be_empty
    end
    it "is not included in global queue" do
      Delayed::Job.find_available(nil, 1).should be_empty
    end
  end
end
