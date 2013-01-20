#encoding: utf-8 # dark magic for international characters
class ApplicationController < ActionController::Base
  include AppAuthHelper

  helper_method :valuation_period?

  protect_from_forgery

  if Rails.env.production?
    rescue_from ActionController::RoutingError, :with => :render_404
    before_filter :authenticate
  else
    if Rails.env.development?
      before_filter :set_account, :authenticate
    end
  end

  def current_user
    @user
  end

private

  def authenticate
    case authenticate_logic
      when :goto_login
        redirect_to Rails.application.config.login_url
      when :ok
        # nothing for now
      when :reg
        unless request.fullpath == '/members/reg' || # prevent redirect loop
            # make possible to save
            (request.method_symbol == :post && request.fullpath == '/members')
          redirect_to '/members/reg'
        end
      else
        redirect_to '/403'
        return false
    end
  end

  def authenticate_logic
    if remote_user.blank?
      :goto_login
    else
      @user = Member.find_by_login(remote_user)
      if @user.nil?
        if member_on_vir?
          :reg
        else
          :access_denied
        end
      else
        if @user.deleted?
          :deleted
        else
          :ok
        end
      end
    end
  end

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404: #{exception.message}"
    end

    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def set_account
    if Rails.env.development?
      request.env[attribute_mapping[:login]] = 'test'
      request.env[attribute_mapping[:email]] = 'test1@test.cc'
      request.env[attribute_mapping[:full_name]] = 'Teszt Janos'
      request.env[attribute_mapping[:nick]] = 'jani'
      request.env[attribute_mapping[:entitlement]] =
          'urn:geant:niif.hu:sch.bme.hu:entitlement:tag:Simonyi Károly Szakkollégium:16;
          urn:geant:niif.hu:sch.bme.hu:entitlement:körvezető:KIR fejlesztők és Üzemeltetők:106;
          urn:geant:niif.hu:sch.bme.hu:entitlement:tag:KIR fejlesztők és Üzemeltetők:106'
    end
  end

  # determines if we are in a valuation period or not
  def valuation_period?
    Semester.current_valuation_period.present?
  end
end
