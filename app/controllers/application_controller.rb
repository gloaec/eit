class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #check_authorization

  before_filter :set_channels
  before_filter :default_url_options

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def set_channels
    @current_user = current_user || User.new
    @channels = Channel.all.select {|_| can?(:read, _)}
  end

  def default_url_options
    ActionMailer::Base.default_url_options = {:host => 'ghis.x64.me:7777'}
  end

end
