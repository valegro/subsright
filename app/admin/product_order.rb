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
      redirect_to admin_product_orders_path
    else
      resource.update_attributes! shipped: Time.zone.today
      redirect_to admin_product_orders_path, notice: "Shipped #{resource.product.name} to #{resource.customer.name}"
    end
  end

  member_action :reship, method: :patch do
    resource.update_attributes! shipped: nil
    redirect_to admin_product_orders_path, notice: "Will reship #{resource.product.name} to #{resource.customer.name}"
  end

  batch_action :shipped do |ids|
    ProductOrder.find(ids).each { |po| po.update_attributes! shipped: Time.zone.today unless po.shipped }
    redirect_to admin_product_orders_path, notice: 'Selected product orders shipped'
  end

  batch_action :reship do |ids|
    ProductOrder.find(ids).each { |po| po.update_attributes! shipped: nil }
    redirect_to admin_product_orders_path, notice: 'Selected product orders will be reshipped'
  end
end
