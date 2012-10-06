# innen https://github.com/AdamLantos/redmine_http_auth/blob/master/app/helpers/http_auth_helper.rb
# módosítva
module HttpAuthHelper
  unloadable

  def member_attributes
    ['login', 'email', 'fullName', 'nick']
  end

  def set_attributes(member)
    member_attributes.each do |attr|
      member.send(attr + "=", (get_attribute_value attr))
    end
  end

  def remote_user
    request.env['HTTP_UID']
  end

  def get_attribute_value(attribute_name)
    conf = Setting.plugin_redmine_http_auth['attribute_mapping'] # todo
    if conf.nil? || !conf.has_key?(attribute_name)
      nil
    else
      request.env[conf[attribute_name]]
    end
  end

end
