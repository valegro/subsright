ActiveAdmin.register ProductOrder do
  actions :index, :show

  preserve_default_filters!
  filter :purchase, if: false

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
      link_to po.shipped ? 'Reship' : 'Shipped', { action: po.shipped ? :reship : :shipped, id: po }, method: :patch
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
      form_for product_order, url: { action: product_order.shipped ? :reship : :shipped }, method: :patch do |f|
        f.submit value: product_order.shipped ? 'Reship' : 'Shipped'
      end
    end
    active_admin_comments
  end

  member_action :shipped, method: :patch do
    if resource.shipped
      flash[:error] = "Already shipped on #{I18n.l resource.shipped, format: :long}"
    elsif resource.product.stock == 0
      flash[:error] = resource.product.name + ' is out of stock'
    else
      resource.product.update! stock: resource.product.stock - 1 if resource.product.stock
      resource.update! shipped: Time.zone.today
      flash[:notice] = "Shipped #{resource.product.name} to #{resource.customer.name}"
    end
    redirect_to admin_product_orders_path
  end

  member_action :reship, method: :patch do
    resource.update! shipped: nil
    redirect_to admin_product_orders_path, notice: "Will reship #{resource.product.name} to #{resource.customer.name}"
  end

  batch_action :shipped do |ids|
    count = 0

    ProductOrder.find(ids).each do |po|
      next if po.shipped || po.product.stock == 0
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
    redirect_to admin_product_orders_path
  end

  batch_action :reship do |ids|
    ProductOrder.find(ids).each { |po| po.update! shipped: nil }
    redirect_to admin_product_orders_path, notice: 'Selected product orders will be reshipped'
  end
end
