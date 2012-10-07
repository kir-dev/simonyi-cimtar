#encoding: utf-8 # dark magic az ékezetes karakterekhez
class ApplicationController < ActionController::Base
  include HttpAuthHelper

  protect_from_forgery

  if Rails.env.development? or Rails.env.test?
    before_filter :set_account, :validate_attributes, :authenticate
  else #production
    before_filter :validate_attributes, :authenticate
  end

  private
  def init_local_login
    if Rails.env.development?
      request.env[attribute_mapping['login']] = 'test'
      request.env[attribute_mapping['email']] = 'test1@test.cc'
      request.env[attribute_mapping['full_name']] = 'Teszt Janos'
      request.env[attribute_mapping['nick']] = 'jani'
      request.env[attribute_mapping['entitlement']] =
          'urn:geant:niif.hu:sch.bme.hu:entitlement:tag:Simonyi Károly Szakkollégium:16;
          urn:geant:niif.hu:sch.bme.hu:entitlement:körvezető:KIR fejlesztők és Üzemeltetők:106;
          urn:geant:niif.hu:sch.bme.hu:entitlement:News admin:KIR fejlesztők és Üzemeltetők:106;
          urn:geant:niif.hu:sch.bme.hu:entitlement:PéK admin:KIR fejlesztők és Üzemeltetők:106;
          urn:geant:niif.hu:sch.bme.hu:entitlement:tag:KIR fejlesztők és Üzemeltetők:106;
          urn:geant:niif.hu:sch.bme.hu:entitlement:tag:Simonyi Konferencia:371'
    end
  end

  protected
  def set_account
    init_local_login
  end

  def validate_attributes
    if remote_user.nil?
      redirect_to(Rails.application.config.login_url)
    else
      entitlement = get_attribute_value 'entitlement'
      if entitlement.nil? or !entitlement.include? ENTITLEMENT_SZK
        render :file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false
        return false
      end
    end
  end

  def authenticate
    @member = Member.find_by_login(remote_user)
    if @member.nil?
      # autoreg
      puts 'reg'
    end
  end
end
