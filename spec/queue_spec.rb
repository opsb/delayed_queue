require 'spec/spec_helper'

describe Delayed::Backend::ActiveRecord::Queue do
  it { should have_many :jobs }
  context "a queue" do
    before do
      @queue = Delayed::Backend::ActiveRecord::Queue.new
    end

    it "can be locked" do
      @queue.lock
      @queue.locked.should == true
    end
  end

  context "a locked queue" do
    before do
      @queue = Delayed::Backend::ActiveRecord::Queue.new
      @queue.lock
    end
    it "can be unlocked" do
      @queue.unlock
      @queue.locked.should == false
    end
  end
end
