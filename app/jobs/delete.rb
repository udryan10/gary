class Delete
  @queue = :delete

  def self.perform(schedule_id)
    log = Logger.new 'log/rescue.log'
    
    @schedule = Schedule.find(schedule_id)
    email = @schedule.user.email
    
    agent = Mechanize.new
    Mechelper.posting_delete(schedule_id)
    #$redis.set(schedule_id, 2)
    @schedule.destroy
  end
end