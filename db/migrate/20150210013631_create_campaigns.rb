class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.text :name, null: false
      t.date :start
      t.date :finish

      t.timestamps null: false
    end
  end
end
