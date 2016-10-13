class CreateGrains < ActiveRecord::Migration[5.0]
  def change
    create_table :grains do |t|
      t.string :name

      t.timestamps
    end
  end
end
