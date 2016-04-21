class AddScoreToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :score, :integer
  end
end
