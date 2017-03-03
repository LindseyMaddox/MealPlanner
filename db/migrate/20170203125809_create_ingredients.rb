class CreateIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :food_group_id
      t.string :integer

      t.timestamps
    end
  end
end
