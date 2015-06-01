class CustomersController < InheritedResources::Base
  respond_to :html, :json, :xml

  private

  def customer_params
    params.require(:customer).permit(:user_id, :name, :email, :phone, :address, :country, :postcode, :currency)
  end
end
