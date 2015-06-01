ActiveAdmin.register AdminUser do
  permit_params :name, :email

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :name
      row :email
      row :unconfirmed_email
      row :confirmation_sent_at
      row :confirmed_at
      row :reset_password_sent_at
      row :remember_created_at
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :failed_attempts
      row :locked_at
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs 'Admin Details' do
      f.input :name
      f.input :email
    end
    f.actions
  end
end
