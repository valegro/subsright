class RenamePaymentsToRenewals < ActiveRecord::Migration
  def change
    rename_table :payments, :renewals
  end
end
