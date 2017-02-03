class RemoveIntegerColumnFromIngredients < ActiveRecord::Migration[5.0]
  def change
  	remove_column :ingredients, :integer
  end
end
