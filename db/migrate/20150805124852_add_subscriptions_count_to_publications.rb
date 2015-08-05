class AddSubscriptionsCountToPublications < ActiveRecord::Migration

  def self.up
    add_column :publications, :subscriptions_count, :integer, null: false, default: 0
    execute 'UPDATE publications SET subscriptions_count = count
      FROM ( SELECT publication_id, COUNT(*) FROM subscriptions GROUP BY publication_id ) AS c
      WHERE publications.id = publication_id;'
  end

  def self.down
    remove_column :publications, :subscriptions_count
  end

end
