class ChangeColumnNamePins < ActiveRecord::Migration
  def change
  	rename_column :pins, :ingredients, :menu
  	rename_column :pins, :method, :openinghours
  	rename_column :pins, :preparation, :kitchen
  	rename_column :pins, :ingredients2, :neighbourhood
  end
end
