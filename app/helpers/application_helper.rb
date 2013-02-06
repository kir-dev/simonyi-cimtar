module ApplicationHelper
  
  def map_flash_message(sym)
    return :info if sym == :notice
    sym
  end

  def translate_role(role, downcase = false)
    trans = t("roles.#{role.name}")
    if downcase
      trans.downcase
    else
      trans
    end
  end

end