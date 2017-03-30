class ChangeFoodGroupColumnsOnIngredients < ActiveRecord::Migration[5.0]
  #accidental migration, was supposed to be on ingredients
  def change
  	remove_column :recipes, :integer
  end
end
