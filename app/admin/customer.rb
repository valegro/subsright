ActiveAdmin.register Customer do
  permit_params :user_id, :name, :email, :phone, :address, :country, :postcode,
    customer_discounts_attributes: [:id, :discount_id, :reference, :expiry, :_destroy],
    subscriptions_attributes:
      [:id, :publication_id, :user_id, :subscribers, :subscribed, :expiry, :cancellation_reason, :_destroy]

  preserve_default_filters!
  filter :customer_discounts, if: false
  filter :customer_subscriptions, if: false
  filter :product_orders, if: false
  filter :publications
  filter :subscriptions, if: false

  index do
    selectable_column
    id_column
    column :user
    column :name
    column :email
    column :phone
    column :address
    column :country
    column :postcode
    column :discounts do |customer|
      ( customer.discounts.order(:name)
        .map { |discount| link_to discount.name, admin_discount_path(discount) }
      ).join(', ').html_safe
    end
    column :subscriptions do |customer|
      ( customer.subscriptions.by_name
        .map { |subscription| link_to subscription.publication.name, admin_subscription_path(subscription) }
      ).join(', ').html_safe
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :user
      row :name
      row :email
      row :phone
      row :address
      row :country
      row :postcode
      row :discounts do
        ( customer.discounts.order(:name)
          .map { |discount| link_to discount.name, admin_discount_path(discount) }
        ).join(', ').html_safe
      end
      row :subscriptions do
        ( customer.subscriptions.by_name
          .map { |subscription| link_to subscription.publication.name, admin_subscription_path(subscription) }
        ).join(', ').html_safe
      end
      row :product_orders do
        ( customer.product_orders.where('shipped IS NULL')
          .map { |po| link_to po.product.name, admin_product_order_path(po) }
        ).join(', ').html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Customer Details' do
      f.input :user
      f.input :name
      f.input :email
      f.input :phone
      f.input :address
      f.input :country
      f.input :postcode
      f.has_many :customer_discounts, allow_destroy: true, heading: 'Customer discounts',
        for: [:customer_discounts, f.object.customer_discounts.by_name] do |fcd|
        fcd.input :discount
        fcd.input :reference
        fcd.input :expiry, as: :datepicker
      end
      f.has_many :subscriptions, allow_destroy: true, heading: 'Subscriptions',
        for: [:subscriptions, f.object.subscriptions.by_name] do |fs|
        fs.input :publication
        fs.input :user
        fs.input :subscribers
        fs.input :subscribed, as: :datepicker
        fs.input :expiry, as: :datepicker
        fs.input :cancellation_reason
      end
    end
    f.actions
  end
end
