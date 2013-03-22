module GroupAdmin::PostsHelper

  # a post can be edited if its not a predefined role
  def can_edit_post?(post)
    !ActingRole.roles.include?(post.title.to_sym)
  end
end