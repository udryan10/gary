require 'rake'
namespace :cl do
  task :validate => :environment do
    schedules = Schedule.all
    schedules.each do |schedule|
      Resque.enqueue(Validate, schedule.id)
    end
  end
end
