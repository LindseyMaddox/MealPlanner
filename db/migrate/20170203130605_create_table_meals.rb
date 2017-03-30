class CreateTableMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :meals do |t|
      t.date :meal_date
      t.integer :recipe_id

      t.timestamps
    end
  end
end
