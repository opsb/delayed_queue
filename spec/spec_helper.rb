$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'logger'

require 'active_record'
require 'action_mailer'


ENV['RAILS_ENV'] = 'test'
require 'rails'
require 'shoulda'
require 'looksee/shortcuts'
require 'spec/sample_jobs'

config = YAML.load(File.read('spec/database.yml'))
ActiveRecord::Base.configurations = {'test' => config['sqlite']}
ActiveRecord::Base.establish_connection
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :delayed_jobs, :force => true do |table|
    table.integer  :priority, :default => 0
    table.integer  :attempts, :default => 0
    table.text     :handler
    table.text     :last_error
    table.datetime :run_at
    table.datetime :locked_at
    table.datetime :failed_at
    table.string   :locked_by
    table.timestamps
    
    table.integer :queue_id
  end
  
  create_table :queues, :force => true do |table|
    table.boolean :locked, :default => false
    table.timestamps
  end

  add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'

  create_table :stories, :force => true do |table|
    table.string :text
  end
end


require 'delayed_job'
Delayed::Worker.logger = Logger.new('/tmp/dj.log')
ActiveRecord::Base.logger = Delayed::Worker.logger
Delayed::Worker.backend = :active_record
# Purely useful for test cases...
class Story < ActiveRecord::Base
  def tell; text; end       
  def whatever(n, _); tell*n; end
  
  handle_asynchronously :whatever
end
require 'delayed_queue'
# Add this directory so the ActiveSupport autoloading works
ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)
