class AddClurlToSchedule < ActiveRecord::Migration
  def change
    change_table :schedules do |t|
      t.text :clurl
    end    
  end
end