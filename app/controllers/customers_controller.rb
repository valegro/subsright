class CustomersController < InheritedResources::Base
  respond_to :html, :json, :xml

  private

  def customer_params
    params.require(:customer)
      .permit(:name, :email, :password, :password_confirmation, :phone, :address, :country, :postcode, :currency)
  end
end
