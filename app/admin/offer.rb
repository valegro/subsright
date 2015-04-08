ActiveAdmin.register Offer do
  permit_params :name, :expires, :description, campaign_ids: [], publication_ids: [], product_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :expires
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
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :expires
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
      f.input :name, as: :string
      f.input :expires
      f.input :campaigns
      f.input :publications
      f.input :products
      f.input :description, input_html: { :class => 'tinymce' }
    end
    f.actions
  end
end
