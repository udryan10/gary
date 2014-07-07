class ChangeActiveColumn < ActiveRecord::Migration
  def change
    change_table :schedules do |t|
      t.integer :active, default: 0
    end    
  end
end