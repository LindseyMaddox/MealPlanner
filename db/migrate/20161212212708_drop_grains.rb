class DropGrains < ActiveRecord::Migration[5.0]
  def change
  	drop_table :grains
  end
end
