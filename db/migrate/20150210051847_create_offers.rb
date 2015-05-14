class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :name, null: false
      t.date :start
      t.date :finish
      t.integer :trial_period
      t.text :description

      t.timestamps null: false
    end
  end
end
