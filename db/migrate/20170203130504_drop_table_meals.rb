class DropTableMeals < ActiveRecord::Migration[5.0]
  def change
  	drop_table :meals
  end
end
