$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rubygems'
require "bundler/setup"
require 'test/unit'
require 'shoulda'
require 'logger'
require 'active_record'
require 'delayed_job'
require 'sqlite3'

Delayed::Worker.logger = Logger.new('/tmp/dj.log')
ENV['RAILS_ENV'] = 'test'

config = YAML.load(File.read('test/database.yml'))
ActiveRecord::Base.establish_connection config['sqlite']
ActiveRecord::Base.logger = Delayed::Worker.logger
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
  end

  add_index :delayed_jobs, [:priority, :run_at], :name => 'delayed_jobs_priority'

  create_table :stories, :force => true do |table|
    table.string :text
  end
end


Delayed::Worker.backend = :active_record
