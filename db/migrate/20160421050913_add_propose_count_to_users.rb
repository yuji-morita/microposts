class AddProposeCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :propose_count, :integer
  end
end
