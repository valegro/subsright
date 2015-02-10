ActiveAdmin.register Offer do
  permit_params :name, :expires, campaign_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :expires
    column 'Campaigns' do |offer|
      (offer.campaigns.map { |campaign| campaign.name }).join(', ').html_safe
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :expires
      row 'Campaigns' do |offer|
        (offer.campaigns.map { |campaign| campaign.name }).join(', ').html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Offer Details" do
      f.input :name
      f.input :expires
      f.input :campaigns
    end
    f.actions
  end

end
