require 'spec/spec_helper'

describe Delayed::Backend::ActiveRecord::Queue do
  it { should have_many :jobs }
end