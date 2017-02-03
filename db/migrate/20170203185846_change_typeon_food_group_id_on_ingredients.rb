class ChangeTypeonFoodGroupIdOnIngredients < ActiveRecord::Migration[5.0]
  def change
  	change_column :ingredients, :food_group_id, :integer
  end
end
