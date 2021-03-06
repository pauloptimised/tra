class ApplicationController < ActionController::Base
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: -> { render_error(500) }
    rescue_from ActiveRecord::RecordNotFound, with: -> { render_error(404) }
    rescue_from ActionController::RoutingError, with: -> { render_error(404) }
  end

  def render_error(status)
    respond_to do |format|
      format.html { render 'errors/404', status: status }
      format.all { render nothing: true, status: status }
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :global_site_settings, :load_objects

  include PresenterHelper

  def index
    @presented_articles = present_collection(Article.displayed.limit(3))
    @presented_home_page_banners = present_collection(HomePageBanner.displayed)
    @presented_additional_content = present(AdditionalContent.area('Home page'))
    @presented_interests = present_collection(Interest.displayed)
  end

  private

  def load_objects
    @header_menu = Optimadmin::Menu.new(name: 'header')
    @footer_menu = Optimadmin::Menu.new(name: 'footer')
  end

  def global_site_settings
    @global_site_settings ||= Optimadmin::SiteSetting.current_environment
  end
  helper_method :global_site_settings
end
