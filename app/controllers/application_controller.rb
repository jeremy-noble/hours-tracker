class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to login_url, :alert => exception.message
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
  end
end
