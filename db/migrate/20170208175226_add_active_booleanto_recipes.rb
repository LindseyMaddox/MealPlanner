class AddActiveBooleantoRecipes < ActiveRecord::Migration[5.0]
  def change
  	add_column :recipes, :active, :boolean
  end
end