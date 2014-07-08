class AddClpassToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.text :clpass
    end    
  end
end