class ChangeTypeonFoodGroupIdOnIngredients < ActiveRecord::Migration[5.0]
   class << self
    include AlterColumn
  end

  def change
  	change_column :ingredients, :food_group_id, :integer, "USING CAST(food_group_id AS integer)", 1
  end
end
