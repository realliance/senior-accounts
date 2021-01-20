# frozen_string_literal: true

worker_processes Integer(ENV['WEB_CONCURRENCY'] || 3)
timeout 15
preload_app true

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    # rubocop:disable Rails/Output
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    # rubocop:enable Rails/Output
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    # rubocop:disable Rails/Output
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
    # rubocop:enable Rails/Output
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
