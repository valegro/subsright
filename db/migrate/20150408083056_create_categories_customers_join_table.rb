class CreateCategoriesCustomersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :categories, :customers do |t|
      t.index [:customer_id, :category_id], unique: true
    end
  end
end
