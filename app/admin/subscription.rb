ActiveAdmin.register Subscription do
  permit_params :publication_id, :user_id, :subscribers, :subscribed, :expiry, :cancellation_reason,
    customers_attributes: [:id, :user_id, :name, :email, :phone, :address, :country, :postcode, :_destroy]

  preserve_default_filters!
  filter :customer_subscriptions, if: false
  filter :payments, if: false

  index do
    selectable_column
    id_column
    column :publication
    column :user
    column :subscribers
    column :subscribed
    column :expiry
    column :cancellation_reason
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :publication
      row :user
      row :subscribers
      row :subscribed
      row :expiry
      row :cancellation_reason
      row :customers do
        ( subscription.customers.order(:name)
          .map { |customer| link_to customer.name, admin_customer_path(customer) }
        ).join(', ').html_safe
      end
      row :purchases do
        ul do
          subscription.payments.order(:purchase_id)
            .each { |p| li sanitize(p.price_name) + ' ' + link_to(p.purchase.status, admin_purchase_path(p.purchase)) }
        end
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Subscription Details' do
      f.input :publication
      f.input :user
      f.input :subscribers
      f.input :subscribed, as: :datepicker
      f.input :expiry, as: :datepicker
      f.input :cancellation_reason
      f.has_many :customers, allow_destroy: true, heading: 'Customers',
        for: [:customers, f.object.customers.order(:name)] do |fc|
        fc.input :user
        fc.input :name
        fc.input :email
        fc.input :phone
        fc.input :address
        fc.input :country
        fc.input :postcode
      end
    end
    f.actions
  end
end
