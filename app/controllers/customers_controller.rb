class CustomersController < InheritedResources::Base
  before_action :authenticate_user!
  respond_to :html, :json, :xml

  def index
    @customers = current_user.customers.order(:name, :created_at)
  end

  private

  def customer_params
    params.require(:customer).permit(:user_id, :name, :email, :phone, :address, :country, :postcode, :currency)
  end
end
