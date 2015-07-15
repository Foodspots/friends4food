class ChangeColumnNamePins2 < ActiveRecord::Migration
  def change
  	rename_column :pins, :type, :category
  end
end
