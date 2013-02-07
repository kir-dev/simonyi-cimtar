class Admin::RolesController < ApplicationController

  def index
    # TODO: make it searchable
    @members = Member.all
  end

  def manage
    @member = Member.find(params[:member_id])
  end

  # adds a role to a member's role list
  def create
    # TODO: permission check
    @member = Member.find params[:member_id]
    roles = MemberRole.where name: params[:role][:name], group_id: params[:role][:group_id]

    if roles.size > 1
      logger.error "More than one member_role in db for one role type and group!"
      flash.now[:error] = "Something went really wrong. Contact maintainers!"
      render :manage
      return
    end

    role = roles.first

    # this saves to db as well
    if not @member.roles.include?(role)
      flash[:success] = t "messages.role_added", :role
      @member.roles << role
    else
      flash[:warning] = t "messages.user_already_has_role", :role => view_context.translate_role(role, true)
    end

    redirect_to admin_roles_path
  end

  # removes a role from a member's role list
  # called via ajax
  def destroy
    @member = Member.find params[:member_id]
    @role = @member.roles.find params[:id]
    if @member.roles.delete @role
      render text: {success: true}.to_json
    else
      render text: {success: false, error_message: "Couldn't take role from user (#{@member.name})"}.to_json
    end
  end

  # POST /admin/roles/member_search
  # kereses a tagok kozott
  def member_search
    # TODO: make searching smart
    name = params[:member_name]

    @members = Member.where "full_name LIKE ?", "#{name}%"
    render "member_search_result", layout: false
  end

end