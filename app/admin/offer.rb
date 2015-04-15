ActiveAdmin.register Offer do
  permit_params :name, :expiry, :description, campaign_ids: [], publication_ids: [], product_ids: [], price_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :expiry
    column 'Campaigns' do |offer|
      (offer.campaigns.map { |campaign| link_to campaign.name, admin_campaign_path(campaign) }).
      join(', ').html_safe
    end
    column 'Publications' do |offer|
      (offer.publications.map { |publication| link_to publication.name, admin_publication_path(publication) }).
      join(', ').html_safe
    end
    column 'Products' do |offer|
      (offer.products.map { |product| link_to product.name, admin_product_path(product) }).
      join(', ').html_safe
    end
    column 'Prices' do |offer|
      (offer.prices.map { |price| link_to "#{price.currency} #{price.name}", admin_price_path(price) }).
      join(', ').html_safe
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :expiry
      row 'Campaigns' do
        (offer.campaigns.map { |campaign| link_to campaign.name, admin_campaign_path(campaign) }).
        join(', ').html_safe
      end
      row 'Publications' do
        (offer.publications.map { |publication| link_to publication.name, admin_publication_path(publication) }).
        join(', ').html_safe
      end
      row 'Products' do
        (offer.products.map { |product| link_to product.name, admin_product_path(product) }).
        join(', ').html_safe
      end
      row 'Prices' do
        (offer.prices.map { |price| link_to "#{price.currency} #{price.name}", admin_price_path(price) }).
        join(', ').html_safe
      end
      row :description do
        offer.description.html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Offer Details" do
      f.input :name
      f.input :expiry, as: :datepicker
      f.input :campaigns, as: :check_boxes
      f.input :publications, as: :check_boxes
      f.input :products, as: :check_boxes
      f.input :prices, as: :check_boxes
      f.input :description, input_html: { :class => 'tinymce' }
    end
    f.actions
  end
end
