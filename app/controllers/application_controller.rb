class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization :unless => :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
  	#Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    #redirect_to root_url, :alert => exception.message
    render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
  end

  # http://stackoverflow.com/questions/15174210/how-to-not-show-menu-included-in-application-html-erb-on-some-urls-in-rails
  before_filter :init_config

	def init_config
	  @config = { :index => false }
	end
end
