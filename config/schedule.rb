# Whenever Schedule
set :output, { error: "#{Whenever.path}/log/cron_error.log", standard: "#{Whenever.path}/log/cron.log"}

every 1.day do
  rake 'products:import:csv'
end
