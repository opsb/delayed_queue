require 'spec/spec_helper'

describe Delayed::Queue do
  it { should have_many :jobs }
end