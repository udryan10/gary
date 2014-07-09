class Mechelper
  
  def self.login (mechagent, username, password)
    agent = mechagent
    agent.get("https://accounts.craigslist.org/")
    agent.page.forms[0]["inputEmailHandle"] = username
    agent.page.forms[0]["inputPassword"] = password
    agent.page.forms[0].submit
    return agent
  end

  def self.posting_delete(schedule_id)

    @schedule = Schedule.find(schedule_id)
    username = @schedule.user.email
    password = "g1hfwtfbbq"
    posting_id = @schedule.posting
    agent = Mechanize.new
    agent = Mechelper.login(agent, username, password)
    puts "Logged in..."

    get_url = "https://post.craigslist.org/manage/#{posting_id}?action=delete&go=Delete+this+Posting"
    agent.get(get_url)
    agent.page.form_with(:method => "POST") do |form|
    end.submit
  end

  def self.post_listing(username,password,city_code,listing_type,p_title,p_price,p_zip,p_body)
    agent = Mechanize.new

    agent = Mechelper.login(agent, username, password)
    puts "Logged in..."

    puts "username #{username}"
    puts "password #{password}"
    puts "city #{city_code}"
    puts "listing_type #{listing_type}"
    puts "title #{p_title}"
    puts "price #{p_price}"
    puts "zip #{p_zip}"
    puts "body #{p_body}"

    #From the account page, select city and open new listing form
    agent.page.form_with(:class => "new_posting_thing") do |form|
      city_field = form.field_with(:name => "areaabb")
      city_field.value = city_code
    end.submit
    puts "Opened new listing form..."

    #Select the type of listing being posted
    agent.page.form_with(:class => "catpick picker") do |form|
      form.radiobutton_with(:value => listing_type).check
    end.submit
    puts "Selected cateogry..."

    #Fill out the listing form
    agent.page.form_with(:id => "postingForm") do |form|
      posting_title = form.field_with(:name => "PostingTitle")
      posting_title.value = p_title

      price = form.field_with(:name => "Ask")
      price.value = p_price

      zip = form.field_with(:name => "postal")
      zip.value = p_zip

      body = form.field_with(:name => "PostingBody")
      body.value = p_body
    end.submit
    puts "Filled out listing form..."

    #Click through additional pages
    form = agent.page.forms.detect { |f| f.button_with(:class => "done bigbutton" ) }
    button = form.button_with(:class => "done bigbutton")
    agent.submit(form, button)
    puts "Clicking through additional menus..."

    #Publish the listing
    form = agent.page.forms.detect { |f| f.button_with(:value => "Continue" ) }
    button = form.button_with(:value => "Continue")
    agent.submit(form, button)
    puts "Published listing"

    lasturl = agent.page.body
    match = /"(http:\/\/.*.craigslist.org\/.*\/(\d*).html)"/.match(lasturl)
    {:url => match[1], :id => match[2]}
  end
end