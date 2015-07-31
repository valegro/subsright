class AddTimeZoneToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :time_zone, :string
  end
end
