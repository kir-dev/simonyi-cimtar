module GroupAdmin::MemberPostsHelper
  
  def ability_selector(form_builder)
    checkboxes = []
    Permission::ABILITIES.each do |a|
      checkboxes << form_builder.label("can_" + a.to_s, :class => "checkbox") do
        form_builder.check_box("can_" + a.to_s) + t("ability." + a.to_s)
      end
    end
    checkboxes.join("\n").html_safe
  end

  def ability_list(permission)
    if permission.manage?
      t "ability.manage"
    else
      permission.abilities.map { |a| t "ability." + a.to_s }.join(', ')
    end
  end

end