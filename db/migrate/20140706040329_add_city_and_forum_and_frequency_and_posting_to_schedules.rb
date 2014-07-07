class AddCityAndForumAndFrequencyAndPostingToSchedules < ActiveRecord::Migration
  def change
    change_table :schedules do |t|
      t.text :city
      t.text :forum
      t.text :frequency
      t.text :posting
      t.references :user, index: true
    end    
  end
end
