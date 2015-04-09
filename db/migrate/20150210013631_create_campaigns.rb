class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :name, null: false
      t.date :start
      t.date :finish
      t.text :description

      t.timestamps null: false
    end
  end
end
