class CreateResponseRelations < ActiveRecord::Migration
  def change
    create_table :response_relations do |t|
      t.references :post, index: true
      t.references :act, index: true
      t.references :rec
      
      t.timestamps null: false
      
    end
  end
end
