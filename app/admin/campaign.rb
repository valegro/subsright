ActiveAdmin.register Campaign do
  permit_params :name, :start, :finish, :description, offer_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :start
    column :finish
    column 'Offers' do |campaign|
      ( campaign.offers.map { |offer| link_to offer.name, admin_offer_path(offer) }
      ).join(', ').html_safe
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
      row 'Offers' do
        ( campaign.offers.map { |offer| link_to offer.name, admin_offer_path(offer) }
        ).join(', ').html_safe
      end
      row :description do
        campaign.description.html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Campaign Details' do
      f.input :name
      f.input :start, as: :datepicker
      f.input :finish, as: :datepicker
      f.input :offers, as: :check_boxes
      f.input :description, input_html: { class: 'tinymce' }
    end
    f.actions
  end

end
