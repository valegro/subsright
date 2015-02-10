ActiveAdmin.register Campaign do
  permit_params :name, :start, :finish

  index do
    selectable_column
    id_column
    column :name
    column :start
    column :finish
    column :created_at
    actions
  end

  filter :name
  filter :start
  filter :finish
  filter :created_at

end
