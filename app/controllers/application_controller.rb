class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to login_url, :alert => exception.message
  end
end
