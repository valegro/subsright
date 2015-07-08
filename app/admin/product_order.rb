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
    actions
  end

  show do
    attributes_table do
      row :customer
      row :purchase
      row :product
      row :shipped
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
