# ==============================================================================
# SETUP
# ==============================================================================
cmd_prefix = "GEM_HOME=#{status.gem_home} RACK_ENV=#{node.environment.framework_env} RAILS_ENV=#{node.environment.framework_env}"

# ==============================================================================
# START DELAYED JOBS
#
# Note:
#
#  - *pid_dir* needs to exist.
# ==============================================================================
execute 'Generate foreman environment file' do
  always_run true
  owner app[:user]
  path current_path
  command "/bin/sh -l -c 'echo \"#{cmd_prefix.split(' ').join('\n')}\" > .env'"
end

execute 'Run foreman to generate upstart services' do
  always_run true
  owner app[:user]
  path current_path
  command "/bin/sh -l -c 'sudo foreman export upstart /etc/init -a delayed_jobs -l /data/productshots/current/log -u deploy'"
end

# execute 'Stop delayed jobs' do
#   always_run true
#   owner app[:user]
#   path current_path
#   command "/bin/sh -l -c '#{cmd_prefix} RAILS_ENV=production script/delayed_job stop'"
# end

# execute 'Start delayed jobs' do
#   always_run true
#   owner app[:user]
#   path current_path
#   command "/bin/sh -l -c '#{cmd_prefix} RAILS_ENV=production script/delayed_job -n 2 start'"
# end

# execute 'Installing cron jobs' do
#   always_run true
#   owner app[:user]
#   path release_path
#   command "#{cmd_prefix} whenever --load-file config/schedule.rb -w"
# end

