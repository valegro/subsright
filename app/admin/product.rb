ActiveAdmin.register Product do
  permit_params :name, :image, :stock, :description, offer_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :image do |product|
      if product.image?
        image_tag(product.image.url(:thumb), height: '100')
      else
        content_tag(:span, 'None')
      end
    end
    column :stock
    column 'Offers' do |product|
      (product.offers.map { |offer| link_to offer.name, admin_offer_path(offer) }).
      join(', ').html_safe
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
      row 'Offers' do
        (product.offers.map { |offer| link_to offer.name, admin_offer_path(offer) }).
        join(', ').html_safe
      end
      row :description do
        product.description.html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :image, as: :file, hint: if f.product.image?
        image_tag(f.product.image.url)
      else
        content_tag(:span, 'Please upload an image')
      end
      f.input :stock
      f.input :offers
      f.input :description, input_html: { :class => 'tinymce' }
    end
    f.actions
  end

end
