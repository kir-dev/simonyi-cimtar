#encoding: utf-8 # dark magic for international characters
class ApplicationController < ActionController::Base
  include AppAuthHelper

  helper_method :valuation_period?, :permitted_to?

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

protected

  # determines if we are in a valuation period or not
  def valuation_period?
    @is_valuation_period ||= Semester.current_valuation_period.present?
  end

  def authorize!(action, resource, group = nil, *args)
    authorization_check(action, resource, group) { raise NotAuthorized }
    resource
  end

  def permitted_to?(action, resource, group = nil, *args)
    permitted_to = true
    authorization_check(action, resource, group) { permitted_to = false }
    permitted_to
  end

private

  def authorization_check(action, resource, group)
    roles = current_user.get_acting_roles
    permitted = false

    roles.each do |r|
      if r.check(action, resource, group)
        permitted = true
      end
    end

    yield if !permitted
    nil
  end

  def authenticate
    case authenticate_logic
    when :goto_login
      redirect_to Rails.application.config.login_url
    when :ok
      @user.last_active = Time.now
      @user.save
    when :reg
      # prevent redirect loop and make possible to save
      unless request.fullpath == '/members/reg' ||
        (request.method_symbol == :post &&
        (request.fullpath == '/members' || request.fullpath[/\A\/members\/(\d+)\Z/]))

        redirect_to '/members/reg'
      end
    when :wait
      unless request.fullpath == '/members/wait_for_accept'
        redirect_to '/members/wait_for_accept'
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
          :reg
      else
        if @user.deleted?
          :deleted
        else
          if @user.has_valid_membership?
            if @user.last_active.blank?
              :reg # imported member, show reg page first
            else
              :ok # ok, has valid membership, not the first login
            end # last_active blank check
          else
            :wait # member is in the db, but don't have valid membership
          end # valid membership check

        end # deleted check
      end # user nil check
    end # remote_user blank check
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
end
