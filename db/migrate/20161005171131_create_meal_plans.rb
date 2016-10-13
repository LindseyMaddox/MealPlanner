class CreateMealPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :meal_plans do |t|
      t.integer :recipe_id
      t.date :meal_date

      t.timestamps
    end
  end
end
