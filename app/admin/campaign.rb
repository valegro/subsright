ActiveAdmin.register Campaign do
  permit_params :name, :start, :finish, offer_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :start
    column :finish
    column 'Offers' do |campaign|
      (campaign.offers.map { |offer| link_to offer.name, admin_offer_path(offer) }).
      join(', ').html_safe
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :start
      row :finish
      row 'Offers' do |campaign|
        (campaign.offers.map { |offer| link_to offer.name, admin_offer_path(offer) }).
        join(', ').html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Campaign Details" do
      f.input :name, input_html: { rows: 1 }
      f.input :start
      f.input :finish
      f.input :offers
    end
    f.actions
  end

end
