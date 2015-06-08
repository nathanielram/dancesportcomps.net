class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  check_authorization :unless => :devise_controller?
  #check_authorization :unless => :rails_admin_controller?
  check_authorization :unless => :is_rails_admin_controller?

  rescue_from CanCan::AccessDenied do |exception|
  	#Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    #redirect_to root_url, :alert => exception.message
    render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
  end

  private
  # hack fix -- https://github.com/sferik/rails_admin/issues/2268
  def is_rails_admin_controller?
	(self.class.to_s =~ /RailsAdmin::/) == 0
  end

end
