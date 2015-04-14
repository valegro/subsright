ActiveAdmin.register Price do
  permit_params :currency, :name, :amount
end
