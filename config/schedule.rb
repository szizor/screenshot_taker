# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
set :output, { :error => 'log/cron.error.log', :standard => 'log/cron.log' }

every 1.day, :at => '4:30 am' do
  runner "Productshot.clean_old_records"
end

every 1.minutes do
  command "find /mnt/data/shared/uploads/tmp -maxdepth 1 -mmin +5 -exec rm -rf {} \;"
end
every 1.minutes do
  command "find /mnt/data/shared/uploads/productshot -maxdepth 1 -mmin +5 -exec rm -rf {} \;"
end

# Learn more: http://github.com/javan/whenever
