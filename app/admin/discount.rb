ActiveAdmin.register Discount do
  permit_params :name, :requestable

  index do
    selectable_column
    id_column
    column :name
    column :requestable
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :requestable
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Discount Details" do
      f.input :name, as: :string
      f.input :requestable
    end
    f.actions
  end
end
