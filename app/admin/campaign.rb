ActiveAdmin.register Campaign do
  permit_params :name, :start, :finish, :description, offer_ids: []
  after_destroy :check_model_errors

  controller do
    def check_model_errors(object)
      return unless object.errors.any?
      flash[:error] ||= []
      flash[:error] << object.errors.full_messages
    end
  end

  preserve_default_filters!
  filter :campaign_offers, if: false

  index do
    selectable_column
    id_column
    column :name
    column :start
    column :finish
    column :offers do |campaign|
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
      row :offers do
        ( campaign.offers.map { |offer| link_to offer.name, admin_offer_path(offer) }
        ).join(', ').html_safe
      end
      row :description do
        campaign.description.html_safe if campaign.description
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
