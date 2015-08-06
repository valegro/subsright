ActiveAdmin.register Product do
  permit_params :name, :image, :stock, :description

  filter :name
  filter :image_updated_at
  filter :stock
  filter :shipped_count, label: 'Shipped'
  filter :unshipped_count, label: 'Unshipped'
  filter :offers
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :name
    column :image do |product|
      if product.image?
        image_tag(product.image.url(:thumb), size: '100')
      else
        content_tag(:span, 'None')
      end
    end
    column :stock
    column :shipped, sortable: :shipped_count do |product|
      if product.shipped_count.zero?
        0
      else
        link_to product.shipped_count,
          admin_product_orders_path('q[product_id_eq]' => product.id, 'q[shipped_null]' => false)
      end
    end
    column :unshipped, sortable: :unshipped_count do |product|
      if product.unshipped_count.zero?
        0
      else
        link_to product.unshipped_count,
          admin_product_orders_path('q[product_id_eq]' => product.id, 'q[shipped_null]' => true)
      end
    end
    column :offers do |product|
      ( product.offers.order(:name).map { |offer| link_to offer.name, admin_offer_path(offer) }
      ).join(', ').html_safe
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :image do
        if product.image?
          image_tag(product.image.url)
        else
          content_tag(:span, 'None')
        end
      end
      row :stock
      row :offers do
        ( product.offers.order(:name).map { |offer| link_to offer.name, admin_offer_path(offer) }
        ).join(', ').html_safe
      end
      row :product_orders do
        ( product.product_orders.where('shipped IS NULL')
          .map { |po| link_to po.customer.name, admin_product_order_path(po) }
        ).join(', ').html_safe
      end
      row(:description) { product.description.html_safe unless product.description.nil? }
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Product Details' do
      f.input :name
      hint = f.product.image? ? image_tag(f.product.image.url) : content_tag(:span, 'Please upload an image')
      f.input :image, as: :file, hint: hint
      f.input :stock
      f.input :description, input_html: { class: 'tinymce' }
    end
    f.actions
  end
end
