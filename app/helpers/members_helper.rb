module MembersHelper

  def form_input_feedback_css(member, field, css_class)
    unless member.errors.messages[field]==nil
      ' ' + css_class + ' '
    end
  end

  def form_input_feedback_text(member, field)
    if member.errors.messages[field].empty?
      ''
    else
      ('<span class="help-inline">' + member.errors.messages[field][0] + '</span>').html_safe
    end
  end

end
