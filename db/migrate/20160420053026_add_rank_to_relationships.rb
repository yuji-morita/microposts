class AddRankToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :rank, :integer
  end
end
