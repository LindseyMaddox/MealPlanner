class DropRecipeIngredientMap < ActiveRecord::Migration[5.0]
  def change
  	drop_table :recipe_ingredient_maps
  end
end
