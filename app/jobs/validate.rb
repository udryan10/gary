class Validate
  @queue = :validate

  def self.perform(schedule_id)
    log = Logger.new 'log/rescue.log' #for debug
    schedule = Schedule.find(schedule_id)
    agent = Mechanize.new
    url = schedule.clurl
    agent.get(url)
    body = agent.page.body
    match = /(flagged|deleted|postingbody)/.match(body)
    active = match[1]

    if active == "deleted"
      active = 1
      Resque.enqueue(Post, schedule.id, schedule.user.email)
    elsif active == "flagged"
      active = 1  
      Resque.enqueue(Post, schedule.id, schedule.user.email)
    elsif active == "postingbody"
      active = 2
    else
      active = 5
    end
    schedule.active = active
    schedule.save
  end
end
