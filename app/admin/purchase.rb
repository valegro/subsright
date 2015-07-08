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
        ul do
          purchase.product_orders.order(:product_id).each do |po|
            li do
              link_to( po.product.name, admin_product_path(po.product) ) + ' for ' +
                link_to( po.customer.name, admin_customer_path(po.customer) ) + ': ' +
                link_to( po.shipped ? "shipped #{I18n.l po.shipped, format: :long}" : 'pending',
                  admin_product_order_path(po) )
            end
          end
        end
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
