class AddWelcomedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :welcomed, :boolean, null: false, default: false
  end
end
