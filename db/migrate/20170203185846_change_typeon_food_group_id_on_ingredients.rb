class ChangeTypeonFoodGroupIdOnIngredients < ActiveRecord::Migration[5.0]
  
  def change
  	execute "ALTER TABLE ingredients ALTER COLUMN food_group_id DROP DEFAULT;
	ALTER TABLE ingredients ALTER COLUMN food_group_id TYPE integer
  USING CAST(multiplier as INTEGER);
	ALTER TABLE ingredients ALTER COLUMN food_group_id SET DEFAULT 1;"

  end
end
