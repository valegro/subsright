class ConfirmationsController < Devise::ConfirmationsController
  def show
    if params[:confirmation_token].present?
      @original_token = params[:confirmation_token]
    elsif params[resource_name].try(:[], :confirmation_token).present?
      @original_token = params[resource_name][:confirmation_token]
    end

    find_resource_by_original_token!
    super if resource.nil? || resource.confirmed?
  end

  def confirm
    @original_token = params[resource_name].try(:[], :confirmation_token)
    return redirect_to action: :new unless find_resource_by_original_token!

    resource.assign_attributes(permitted_params) unless params[resource_name].nil?
    return render action: :show unless resource.valid? && resource.password_match?

    resource.confirm!
    set_flash_message :notice, :confirmed
    sign_in_and_redirect resource_name, resource
  end

  private

  def find_resource_by_original_token!
    digested_token = Devise.token_generator.digest(self, :confirmation_token, @original_token)
    self.resource = resource_class.find_by_confirmation_token digested_token
  end

  def permitted_params
    params.require(resource_name).permit(:confirmation_token, :password, :password_confirmation)
  end
end
