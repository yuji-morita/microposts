class AddScoreToResponseRelation < ActiveRecord::Migration
  def change
    add_column :response_relations, :score, :integer
  end
end
