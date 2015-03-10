class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.text :name, null: false
      t.date :expires
      t.text :description

      t.timestamps null: false
    end
  end
end
