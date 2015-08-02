class UsersController < InheritedResources::Base
  before_action :authenticate_user!
  before_action { @user = current_user }
  respond_to :html, :json, :xml
  rescue_from ActiveRecord::RecordInvalid, with: :show_errors

  def update
    flash.notice = 'Profile updated.  Thank you!' if current_user.update! user_params
    redirect_to action: :show
  end

  protected

  def show_errors(exception)
    flash.alert = exception.message
    render :edit
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :time_zone, :currency)
  end
end
