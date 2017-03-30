class ChangeFoodGrouptoAssociation < ActiveRecord::Migration[5.0]
  def change
  	add_column :food_groups, :ingredient_id, :integer 
  end
end
