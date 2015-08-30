ActiveAdmin.register ProductOrder do
  actions :index, :show

  filter :customer
  filter :product
  filter :shipped_null, as: :boolean, label: 'Unshipped'
  filter :shipped
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :customer
    column :purchase
    column :product
    column :shipped
    column :created_at
    column :updated_at
    actions defaults: true do |po|
      unless po.purchase.payment_due
        link_to po.shipped ? 'Reship' : 'Shipped', { action: po.shipped ? :reship : :shipped, id: po }, method: :patch
      end
    end
  end

  show do
    attributes_table do
      row :customer
      row :purchase
      row :product
      row :shipped
      row :created_at
      row :updated_at
      unless product_order.purchase.payment_due
        form_for product_order, url: { action: product_order.shipped ? :reship : :shipped }, method: :patch do |f|
          f.submit value: product_order.shipped ? 'Reship' : 'Shipped'
        end
      end
    end
    active_admin_comments
  end

  member_action :shipped, method: :patch do
    if resource.purchase.payment_due
      return redirect_to :admin_product_orders, flash: { error: 'Purchase not completed' }
    end

    if resource.shipped
      flash[:error] = "Already shipped on #{I18n.l resource.shipped, format: :long}"
    elsif resource.product.stock == 0
      flash[:error] = resource.product.name + ' is out of stock'
    else
      resource.product.update! stock: resource.product.stock - 1 if resource.product.stock
      resource.update! shipped: Time.zone.today
      flash[:notice] = "Shipped #{resource.product.name} to #{resource.customer.name}"
    end

    redirect_to :admin_product_orders
  end

  member_action :reship, method: :patch do
    if resource.shipped
      resource.update! shipped: nil
      flash[:notice] = "Will reship #{resource.product.name} to #{resource.customer.name}"
    end

    redirect_to :admin_product_orders
  end

  batch_action :shipped do |ids|
    count = 0

    ProductOrder.find(ids).each do |po|
      next if po.shipped || po.purchase.payment_due || po.product.stock == 0
      po.product.update! stock: po.product.stock - 1 if po.product.stock
      po.update! shipped: Time.zone.today
      count += 1
    end

    if count == ids.size
      flash[:notice] = 'Selected product orders shipped'
    elsif count > 0
      flash[:alert] = "#{count} selected product " + 'order'.pluralize(count) + ' shipped'
    else
      flash[:error] = 'Product orders could not be shipped'
    end
    redirect_to :admin_product_orders
  end

  batch_action :reship do |ids|
    ProductOrder.find(ids).each { |po| po.update! shipped: nil }
    redirect_to :admin_product_orders, notice: 'Selected product orders will be reshipped'
  end
end
