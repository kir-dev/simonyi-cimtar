# observes MemberRole model by default
class MemberRoleObserver < ActiveRecord::Observer
  observe MemberRole

  # creates a new Post model to record tha fact that a role has been
  # assigned to a member
  def after_create(member_role)
    manage_post(member_role) { |ms, role| ms.posts.create title: role.name, from: Date.current }
  end

  # updates a the post record 'to' field
  def before_destroy(member_role)
    manage_post(member_role) do |ms, role|
      posts = Post.where(membership_id: ms, title: role.name, to: nil).all

      if posts.size > 1
        Rails.logger.error "A member has more than one post with the same name at the same time for one group. Membership id: #{ms.id}"
      end

      p = posts.first
      p.to = Date.current
      p.save
    end
    true
  end

private

  def manage_post(member_role)
    role = member_role.role
    # if the role has a group -> record it in the history table
    if role.group.present?
      ms = Membership.where(member_id: member_role.member, group_id: role.group).first
      yield(ms, role)
    end
  end
end
