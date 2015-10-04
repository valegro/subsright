class AddApiKeyToPublication < ActiveRecord::Migration
  def self.up
    add_column :publications, :api_key, :string
    Publication.all.each { |publication| publication.update! api_key: Devise.friendly_token }
    change_column :publications, :api_key, :string, null: false
    add_index :publications, :api_key, unique: true
  end

  def self.down
    remove_column :publications, :api_key
  end
end
