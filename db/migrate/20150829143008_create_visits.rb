class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.belongs_to :user
	  t.belongs_to :pin
      t.timestamps
    end
  end
end
