class ChangeTypeonFoodGroupIdOnIngredients < ActiveRecord::Migration[5.0]
  
  def change
  	execute "ALTER TABLE ingredients ALTER COLUMN food_group_id DROP DEFAULT;
	ALTER TABLE ingredients ALTER COLUMN food_group_id TYPE integer
  USING CAST(food_group_id as INTEGER);
	ALTER TABLE ingredients ALTER COLUMN food_group_id SET DEFAULT 1;"

  end
end
