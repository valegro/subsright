ActiveAdmin.register Offer do
  permit_params :name, :start, :finish, :description, campaign_ids: [],
    offer_publications_attributes: [:id, :publication_id, :quantity, :unit, :_destroy],
    offer_products_attributes: [:id, :product_id, :optional, :_destroy], price_ids: []

  preserve_default_filters!
  filter :offer_publications, :if => false
  filter :offer_products, :if => false

  index do
    selectable_column
    id_column
    column :name
    column :start
    column :finish
    column 'Campaigns' do |offer|
      ( offer.campaigns.map { |campaign| link_to campaign.name, admin_campaign_path(campaign) }
      ).join(', ').html_safe
    end
    column 'Publications' do |offer|
      ( offer.publications.order('name').map { |publication|
          link_to publication.name, admin_publication_path(publication) }
      ).join(', ').html_safe
    end
    column 'Products' do |offer|
      ( offer.products.order('name').map { |product| link_to product.name, admin_product_path(product) }
      ).join(', ').html_safe
    end
    column 'Prices' do |offer|
      ( offer.prices.map { |price| link_to "#{price.currency} #{price.name}", admin_price_path(price) }
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
      row 'Campaigns' do
        ( offer.campaigns.map { |campaign| link_to campaign.name, admin_campaign_path(campaign) }
        ).join(', ').html_safe
      end
      row 'Publications' do
        ul do
          offer.offer_publications.by_name.each do |op|
            li link_to( op.publication.name, admin_publication_path(op.publication) ) +
              " for " + pluralize(op.quantity, op.unit.downcase)
          end
        end
      end
      row 'Products' do
        ul do
          offer.offer_products.where('optional = FALSE').by_name.each do |op|
            li link_to( op.product.name, admin_product_path(op.product) )
          end
          offer.offer_products.where('optional = TRUE').by_name.each do |op|
            li link_to( op.product.name, admin_product_path(op.product) ) + ' (optional)'
          end
        end
      end
      row 'Prices' do
        ( offer.prices.map { |price| link_to "#{price.currency} #{price.name}", admin_price_path(price) }
        ).join(', ').html_safe
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
      f.input :start, as: :datepicker
      f.input :finish, as: :datepicker
      f.input :campaigns, as: :check_boxes
      f.has_many :offer_publications, allow_destroy: true, heading: 'Offer publications',
        :for => [:offer_publications, f.object.offer_publications.by_name] do |fop|
        fop.input :publication
        fop.input :quantity
        fop.input :unit, as: :radio, collection: OfferPublication::UNITS
      end
      f.has_many :offer_products, allow_destroy: true, heading: 'Offer products',
        :for => [:offer_products, f.object.offer_products.by_name] do |fop|
        fop.input :product
        fop.input :optional
      end
      f.input :prices, as: :check_boxes
      f.input :description, input_html: { :class => 'tinymce' }
    end
    f.actions
  end
end
