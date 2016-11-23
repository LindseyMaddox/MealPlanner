class AddUserIdToMealPlans < ActiveRecord::Migration[5.0]
  def change
  	add_column :meal_plans, :user_id, :integer
  end
end
