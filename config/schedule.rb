set :environment, "development"
set :output, {error: "log/cron_error_log.log", standard: "log/cron_log.log"}

every :day, at: "10:00am" do
  rake "send_user_not_login"
end

every 1.months do
  rake "send_static_end_month"
end

every 1.minutes do
  rake "jobs:work"
end
