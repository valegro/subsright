class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.string :key, null: false
      t.text :value
      t.string :form_type, null: false
      t.string :form_collection_command

      t.timestamps null: false
    end
  end
end
