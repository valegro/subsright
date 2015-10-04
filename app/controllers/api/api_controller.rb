class Api::ApiController < ActionController::Base
  respond_to :json

  def version
    respond_with version: 1
  end

  private

  def authenticate
    authenticate_or_request_with_http_token do |token|
      @publication = Publication.where(api_key: token).first
    end
  end
end
