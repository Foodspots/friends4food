class AddColumnToPin < ActiveRecord::Migration
  def change
    add_column :pins, :type, :string
  end
end
