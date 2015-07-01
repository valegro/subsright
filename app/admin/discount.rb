ActiveAdmin.register Discount do
  permit_params :name, :requestable, price_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :requestable
    column :prices do |discount|
      ( discount.prices.map { |price| link_to "#{price.currency} #{price.name}", admin_price_path(price) }
      ).join(', ').html_safe
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :requestable
      row :prices do
        ( discount.prices.map { |price| link_to "#{price.currency} #{price.name}", admin_price_path(price) }
        ).join(', ').html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Discount Details' do
      f.input :name
      f.input :requestable
      f.input :prices, as: :check_boxes
    end
    f.actions
  end
end
