class DropProteins < ActiveRecord::Migration[5.0]
  def change
  	drop_table :proteins
  end
end
