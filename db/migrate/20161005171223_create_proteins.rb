class CreateProteins < ActiveRecord::Migration[5.0]
  def change
    create_table :proteins do |t|
      t.string :name

      t.timestamps
    end
  end
end
