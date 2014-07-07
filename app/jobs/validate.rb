class Validate
  @queue = :validate

  def self.perform(schedule_id)
    @schedule = Schedule.find(schedule_id)

    log = Logger.new 'log/rescue.log'

    @email = @schedule.user.email
    @password = "g1hfwtfbbq"
    @posting_id = @schedule.posting
    log.error "starts"
    agent = Mechanize.new
    agent = Mechelper.login(agent, @email, @password)
    get_url = "https://post.craigslist.org/manage/#{@posting_id}"
    agent.get(get_url)

    body = agent.page.body
    match = /Your posting can be seen at <a href="(http.*.html)"/.match(body)
    url = match[1]
    log.error url
    agent.get(url)
    body = agent.page.body
    match = /(flagged|deleted|postingbody)/.match(body)
    active = match[1]

    if active == "deleted"
      active = 4
    elsif active == "flagged"
      active = 3
    elsif active == "postingbody"
      active = 2
    else
      active = 5
    end
    @schedule.active = active
    @schedule.save
  end
end
