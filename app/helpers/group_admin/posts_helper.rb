module GroupAdmin::PostsHelper

  def translate_post_title(post)
    # TODO: translation for predefined roles like group_admin
    t(post.title)
  end

  # a post can be edited if its not a predefined role
  def can_edit_post?(post)
    !ActingRole.roles.include?(post.title.to_sym)
  end
end