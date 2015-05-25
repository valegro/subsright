ActiveAdmin.register Price do
  permit_params :currency, :name, :amount

  index do
    selectable_column
    id_column
    column :currency
    column :name
    column :amount
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row(:currency) { price.currency_name }
      row :name
      row :amount
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Price Details' do
      f.input :currency, as: :select, collection: options_for_select(Price.currencies, 'AUD')
      f.input :name
      f.input :amount, required: true
    end
    f.actions
  end
end
