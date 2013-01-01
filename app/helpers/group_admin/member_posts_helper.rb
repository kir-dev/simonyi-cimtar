module GroupAdmin::MemberPostsHelper
  
  def ability_selector(form_builder, selected = [])
    form_builder.select :abilities, 
                        [
                          [t("ability.read"),    "read"],
                          [t("ability.create"),  "create"],
                          [t("ability.update"),  "update"],
                          [t("ability.destroy"), "destroy"]
                        ], 
                        { :selected => selected }, 
                        { :multiple => true }
  end

end