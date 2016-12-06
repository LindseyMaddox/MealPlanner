class RemoveProteinAndGrainIDsfromRecipes < ActiveRecord::Migration[5.0]
  def change
  	remove_column :recipes, :protein_id
  	remove_column :recipes, :grain_id

  end
end
