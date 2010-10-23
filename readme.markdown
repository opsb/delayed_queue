delayed_queue
=============

Extension to allow delayed_job to work with multiple queues.

Installation
------------

		gem 'delayed_queue'

Usage
-----

		jobs = (1..4).map{ ResizeImageJob.new }

		queue1 = Queue.create
		queue1 << jobs[0]
		queue1 << jobs[1]

		queue2 = Queue.create
		queue2 << jobs[2]
		queue2 << jobs[3]

		def next_job
			Delayed::Job.find_available(worker_name) # used by delayed_job's worker.rb to find next job
		end
		
		assert_equal jobs[0], next_job
		queue1.lock
		assert_equal jobs[2], next_job # queue1 locked so jobs[1] is ignored
		queue1.unlock
		assert_equal jobs[1], next_job