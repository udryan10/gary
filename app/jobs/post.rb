class Post
  @queue = :post

  def self.perform(schedule_id, email)
    @schedule = Schedule.find(schedule_id)
    log = Logger.new 'log/rescue.log'
    agent = Mechanize.new
    post_id = Mechelper.post_listing(email,
                            "g1hfwtfbbq", 
                            @schedule.city,
                            @schedule.forum,
                            @schedule.title,
                            @schedule.price,
                            @schedule.zip,
                            @schedule.body)
    #$redis.set(schedule_id, 2)
    @schedule.posting = post_id
    @schedule.save
    Resque.enqueue(Validate, @schedule.id)
  end
end