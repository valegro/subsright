ActiveAdmin.register Purchase do
  actions :index, :show
  config.batch_actions = false
  config.clear_action_items!

  preserve_default_filters!
  filter :payments, if: false
  filter :product_orders, if: false
  filter :subscriptions, if: false

  index do
    id_column
    column :offer
    column :currency
    column :amount
    column :completed_at
    column :receipt
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :offer
      row :currency
      row :amount
      row :completed_at
      row :receipt
      row :subscriptions do
        ( purchase.payments.map { |p| link_to p, admin_subscription_path(p.subscription) } ).join(', ').html_safe
      end
      row :products do
        ( purchase.product_orders.map { |po| link_to po.product.name, admin_product_path(po.product) }
        ).join(', ').html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
