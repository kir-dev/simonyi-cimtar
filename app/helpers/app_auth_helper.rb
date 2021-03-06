#encoding: utf-8 # dark magic az ékezetes karakterekhez
# innen https://github.com/AdamLantos/redmine_http_auth/blob/master/app/helpers/http_auth_helper.rb
# módosítva
module AppAuthHelper
  unloadable

  def member_attributes
    %w(login email full_name nick)
  end

  def attribute_mapping
    {login: 'HTTP_UID',
     email: 'HTTP_EMAIL',
     full_name: 'HTTP_COMMON_NAME',
     nick: 'HTTP_NICKNAME',
     entitlement: 'HTTP_EDUPERSONENTITLEMENT'}
  end

  def set_attributes(member)
    member_attributes.each do |attr|
      member.send(attr + "=", (get_attribute_value attr.to_sym))
    end
  end

  def remote_user
    get_attribute_value :login
  end

  def get_attribute_value(attr_sym)
    if attribute_mapping.has_key?(attr_sym)
      attr = request.env[attribute_mapping[attr_sym]]

      unless attr.nil?
        attr.force_encoding('utf-8')
      end
    else
      nil
    end
  end

end
