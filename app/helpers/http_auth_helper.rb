#encoding: utf-8 # dark magic az ékezetes karakterekhez
# innen https://github.com/AdamLantos/redmine_http_auth/blob/master/app/helpers/http_auth_helper.rb
# módosítva
module HttpAuthHelper
  unloadable

  ENTITLEMENT_SZK = 'urn:geant:niif.hu:sch.bme.hu:entitlement:tag:Simonyi Károly Szakkollégium:16'

  def member_attributes
    ['login', 'email', 'full_name', 'nick']
  end

  def attribute_mapping
    {'login' => 'HTTP_UID',
     'email' => 'HTTP_EMAIL',
     'full_name' => 'HTTP_COMMON_NAME',
     'nick' => 'HTTP_NICKNAME',
     'entitlement' => 'HTTP_EDUPERSONENTITLEMENT'
    }
  end

  def set_attributes(member)
    member_attributes.each do |attr|
      member.send(attr + "=", (get_attribute_value attr))
    end
  end

  def remote_user
    get_attribute_value 'login'
  end

  def get_attribute_value(attribute_name)
    if attribute_mapping.has_key?(attribute_name)
      request.env[attribute_mapping[attribute_name]]
    else
      nil
    end
  end

end
