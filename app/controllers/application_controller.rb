#encoding: utf-8 # dark magic az ékezetes karakterekhez
class ApplicationController < ActionController::Base
  include AppAuthHelper

  protect_from_forgery

  if Rails.env.development?
    before_filter :set_account, :authenticate
  else #production
    before_filter :authenticate
  end

  private
  def authenticate
    case authenticate_logic
      when :goto_login
        redirect_to Rails.application.config.login_url
      when :goto_reg
        puts 'reg'
      when :ok
        puts 'ok'
      else
        redirect_to '/403'
        return false
    end
  end

  private
  def authenticate_logic
    if remote_user.nil? or remote_user.empty?
      :goto_login
    else
      @member = Member.find_by_login(remote_user)
      if @member.nil?
        if is_member_on_vir
          :goto_reg
        else
          :access_denied
        end
      else
        :ok
      end
    end
  end

  private
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
