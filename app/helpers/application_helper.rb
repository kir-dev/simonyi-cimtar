module ApplicationHelper
  
  def map_flash_message(sym)
    return :info if sym == :notice
    sym
  end

end