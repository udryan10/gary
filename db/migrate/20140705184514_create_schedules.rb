class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.text :title
      t.text :body
      t.text :price
      t.text :zip

      t.timestamps
    end
  end
end
