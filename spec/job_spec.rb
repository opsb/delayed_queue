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
      Delayed::Job.in_unlocked_queue.should be_empty
    end

    it "is not ready to run" do
      Delayed::Job.ready_to_run(nil, 1).should be_empty
    end

    it "is not included in global queue" do
      Delayed::Job.find_available(nil, 1).should be_empty
    end

    context "and has failed once" do
      before do
        attempted_job = Delayed::Job.first
        attempted_job.last_error = "stack trace"
        attempted_job.attempts = 1
        attempted_job.save
      end

      it "should still be available in global queue" do
        Delayed::Job.find_available(nil, 1).first.payload_object.should == @job
      end
      
    end

    context "and has failed completely" do
      before do
        Delayed::Job.first.update_attributes :failed_at => Time.now
      end
      it "should not be available in global queue" do
        Delayed::Job.find_available(nil, 1).should be_empty
      end
    end
  end

end
