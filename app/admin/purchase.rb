ActiveAdmin.register Purchase do
  actions :index, :show
  config.batch_actions = false
  config.clear_action_items!

  filter :offer
  filter :products
  filter :currency, as: :select, collection: Configuration::CURRENCY_OPTIONS
  filter :amount_cents
  filter :monthly_payments
  filter :initial_amount_cents
  filter :payment_due
  filter :cancelled_at
  filter :created_at
  filter :updated_at

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
    column :monthly_payments
    column :initial_amount
    column :payment_due
    column :cancelled_at
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :offer
      row :currency
      row :amount
      row :monthly_payments
      row :initial_amount
      row :payment_due
      row :cancelled_at if purchase.cancelled_at
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
      unless purchase.cancelled_at
        purchase.timestamp = Time.zone.now
        render 'update', locals: { purchase: purchase }
      end
    end
    active_admin_comments
  end

  member_action :update, method: :patch do
    @purchase = Purchase.find params[:id]
    case params[:commit]
    when 'Cancel purchase', 'Reverse purchase'
      cancel_purchase!
    when 'Complete purchase'
      complete_purchase!
    end
    redirect_to :admin_purchase
  end
end

def purchase_params
  params.require(:purchase).permit([:commit, :timestamp])
end

def cancel_payment!(p)
  if p.subscription.expiry
    offer_publication = @purchase.offer.offer_publications.where(publication_id: p.subscription.publication).first
    p.subscription.update! expiry: offer_publication.reduce_date(p.subscription.expiry)
  end
  p.destroy if @purchase.payment_due
end

def cancel_purchase!
  return flash[:error] = 'Purchase already cancelled' if @purchase.cancelled_at

  @purchase.payments.each { |p| cancel_payment!(p) }
  @purchase.product_orders.each { |po| po.destroy unless po.shipped }
  @purchase.update! payment_due: nil, cancelled_at: purchase_params[:timestamp]
  flash[:notice] = 'Purchase cancelled'
end

def complete_payment!(p)
  expiry = p.subscription.expiry
  subscribed = p.subscription.subscribed
  offer = @purchase.offer
  expiry = subscribed if expiry == subscribed + (offer.trial_period || 0).days
  offer_publication = offer.offer_publications.where(publication_id: p.subscription.publication).first
  p.subscription.update! expiry: offer_publication.extend_date(expiry || Time.zone.today)
end

def complete_purchase!
  return flash[:error] = 'Purchase already complete' unless @purchase.payment_due

  @purchase.payments.each { |p| complete_payment!(p) }
  @purchase.update! payment_due: nil
  flash[:notice] = 'Purchase complete'
end
