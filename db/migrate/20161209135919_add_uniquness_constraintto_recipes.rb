class AddUniqunessConstrainttoRecipes < ActiveRecord::Migration[5.0]
  def change
  	add_index :recipes, [:name, :user_id], unique: true
  end
end
