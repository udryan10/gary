class SchedulesController < ApplicationController
  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = current_user.schedules.build(schedule_params)
    @email = current_user.email
    @schedule.active = 1
    if @schedule.save
      
      Resque.enqueue(Post, @schedule.id, @email)
      flash[:notice] = "Schedule created successfully."
      redirect_to @schedule
    else
      render "new"
    end
  end

  def show
    @schedule = Schedule.find(params[:id])
    @status = $redis.get(@schedule.id)
  end

  def index
    @user = current_user
    @schedules = @user.schedules
  end

  def edit
    @schedule = Schedule.find(params[:id])
  end

  def update
    @schedule = Schedule.find(params[:id])

    if @schedule.update(schedule_params)
      redirect_to @schedule
    else
      render "edit"
    end 
  end

  def destroy
    @schedule = Schedule.find(params[:id])
    @schedule.destroy

    redirect_to schedules_path
  end
end

private
  def schedule_params
    params.require(:schedule).permit(:title, :body, :price, :zip, :city, :forum, :frequency, :posting, :active)
  end
