class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :name, null: false
      t.string :website, null: false
      t.attachment :image
      t.text :description

      t.timestamps null: false
    end
    add_index :publications, :name, unique: true
  end
end
