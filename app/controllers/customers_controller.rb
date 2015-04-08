class CustomersController < InheritedResources::Base
  respond_to :html, :json, :xml

  private

    def customer_params
      params.require(:customer).permit(:name, :email, :phone, :address, :country, :postcode)
    end
end
