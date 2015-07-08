ActiveAdmin.register Price do
  permit_params :currency, :name, :amount, :monthly_payments, :initial_amount

  preserve_default_filters!
  filter :currency, as: :select, collection: Configuration::CURRENCY_OPTIONS
  filter :discount_prices, if: false
  filter :offer_prices, if: false

  index do
    selectable_column
    id_column
    column :currency
    column :name
    column :amount
    column :monthly_payments
    column :initial_amount
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row(:currency) { price.currency_name }
      row :name
      row :amount
      row :monthly_payments
      row :initial_amount
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Price Details' do
      f.input :currency, as: :select, collection: options_for_select(Configuration::CURRENCY_OPTIONS, 'AUD')
      f.input :name
      f.input :amount, required: true
      f.input :monthly_payments
      f.input :initial_amount
    end
    f.actions
  end
end
