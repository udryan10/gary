require 'rake'
namespace :cl do
  task :validate => :environment do
    schedules = Schedule.all
    schedules.each do |schedule|
      Resque.enqueue(Validate, schedule.id)
    end
  end

#Soon deprecated
  task :post => :environment do
    schedules = Schedule.all
    schedules.each do |schedule|
      unless schedule.active == 1 or schedule.active == 2
        Resque.enqueue(Post, schedule.id, schedule.user.email)
      end
    end
  end
end
