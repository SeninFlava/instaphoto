class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  def set_locale
  	#:debug, :info, :warn, :error, :fatal и :unknown
  	Rails.logger.info "**** Setting locale"
    
    if current_user.nil? || current_user.lang == ""
        
  	   I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
        Rails.logger.info "**** Locale from browser=#{I18n.locale}"   
  	else 
       I18n.locale = current_user.lang
       Rails.logger.info "**** Locale from User=#{I18n.locale}"   
    end
  end


protected

def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :lang])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :lang])
end

end
