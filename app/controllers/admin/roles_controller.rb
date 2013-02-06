class Admin::RolesController < ApplicationController

  def index
    # TODO: make it searchable
    @members = Member.all
  end

  def manage
    @member = Member.find(params[:member_id])
  end

  def create
    # TODO: permission check
    @member = Member.find params[:member_id]
    roles = MemberRoles.where name: params[:role][:name], group_id: params[:role][:group_id]

    if roles.size > 1
      logger.error "More than one member_role in db for one role type and group!"
      flash.now[:error] = "Something went really wrong. Contact maintainers!"
      render :manage
      return
    end

    # this saves to db as well
    @member.roles << roles

    redirect_to admin_roles_path
  end
end
