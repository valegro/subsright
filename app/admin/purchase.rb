ActiveAdmin.register Purchase do
  actions :index, :show
  config.batch_actions = false
  config.clear_action_items!

  preserve_default_filters!
  filter :currency, as: :select, collection: Configuration::CURRENCY_OPTIONS
  filter :payments, if: false
  filter :product_orders, if: false
  filter :subscriptions, if: false

  controller do
    rescue_from ActiveRecord::RecordInvalid, with: :show_errors

    protected

    def show_errors(exception)
      redirect_to :admin_purchase, flash: { error: exception.message }
    end
  end

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
      if purchase.completed_at
        row :completed_at
        row :receipt
      end
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
      unless purchase.completed_at
        purchase.completed_at = Time.zone.now
        render 'complete', locals: { purchase: purchase }
      end
    end
    active_admin_comments
  end

  member_action :complete, method: :patch do
    @purchase = Purchase.find params[:id]
    return redirect_to :admin_purchase, flash: { error: 'Purchase already complete' } if @purchase.completed_at

    @purchase.update! params.require(:purchase).permit([:completed_at, :receipt])
    offer = @purchase.offer
    @purchase.payments.each do |p|
      expiry = p.subscription.expiry
      subscribed = p.subscription.subscribed
      expiry = subscribed if expiry == subscribed + (offer.trial_period || 0).days
      p.subscription.update! expiry: offer.offer_publications.where(publication_id: p.subscription.publication).first
        .extend_date(expiry || Time.zone.today)
    end
    redirect_to :admin_purchase, notice: 'Purchase complete'
  end
end
