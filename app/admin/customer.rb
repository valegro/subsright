ActiveAdmin.register Customer do
  permit_params :name, :email, :phone, :address, :country, :postcode, category_ids: [], publication_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :address
    column :country
    column :postcode
    column 'Categories' do |customer|
      (customer.categories.map { |category| category.name }).
      join(', ').html_safe
    end
    column 'Publications' do |customer|
      (customer.publications.map { |publication| link_to publication.name, admin_publication_path(publication) }).
      join(', ').html_safe
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :phone
      row :address
      row :country
      row :postcode
      row 'Categories' do |customer|
        (customer.categories.map { |category| category.name }).
        join(', ').html_safe
      end
      row 'Publications' do
        (customer.publications.map { |publication| link_to publication.name, admin_publication_path(publication) }).
        join(', ').html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Customer Details" do
      f.input :name, as: :string
      f.input :email, as: :email
      f.input :phone, as: :phone
      f.input :address
      f.input :country, as: :country
      f.input :postcode, as: :string
      f.input :categories
      f.input :publications
    end
    f.actions
  end
end
