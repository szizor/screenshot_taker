
working_directory '/data/productshots/current/'
worker_processes 16
listen '/data/productshots/shared/tmp/pids/productshots.master.sock', :backlog => 1024
timeout 500
pid "/data/productshots/shared/tmp/pids/productshots.master.pid"

# Based on http://gist.github.com/206253

@mylog = Logger.new("log/unicorn.log")

logger @mylog

# Load the app into the master before forking workers for super-fast worker spawn times
### TO USE PRELOAD APP TRUE READ THIS http://unicorn.bogomips.org/SIGNALS.html FIRST
preload_app false

# some applications/frameworks log to stderr or stdout, so prevent
# them from going to /dev/null when daemonized here:
stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

# REE - http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|

  @mylog.info "worker=#{worker.nr} before_fork"

  # the following is recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    @mylog.info "uplug ActiveRecord::Base.connection(#{ActiveRecord::Base.connection})"
  end

  if defined?(MongoMapper)
    MongoMapper.connection.close
    @mylog.info "uplug MongoMapper.connection(#{MongoMapper.connection})"
  end

  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

end

after_fork do |server, worker|

  @mylog.info "worker=#{worker.nr} after_fork"

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    @mylog.info "connect to mysql: #{ActiveRecord::Base.connection.inspect}"
  end

  if defined?(MongoMapper)
    # Mongo connects, by itself.
    @mylog.info "connect to mongodb: #{MongoMapper.connection.inspect}"
  end

  # Automatically generate "Unicorn worker pid file base" upon worker spawning.
  child_pid = server.config[:pid].sub('.master.pid', ".worker.#{worker.nr + 1}.pid")
  system("echo #{Process.pid} > #{child_pid}")

end

