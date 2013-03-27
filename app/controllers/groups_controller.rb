class GroupsController < ApplicationController

  # GET /groups
  def index
    authorize! :list, Group
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /groups/1
  def show
    @group = Group.includes(:memberships).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /groups/new
  def new
    authorize! :create, Group
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
    authorize! :update, Group, @group
  end

  # POST /groups
  def create
    authorize! :create, Group
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /groups/1
  def update
    @group = Group.find(params[:id])
    authorize! :update, Group, @group

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: t("messages.group.successfully_updated") }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # POST /groups/1/join
  def join
    @group = Group.find(params[:id])
    if @group.has_member?(@user)
      flash[:notice] = t 'group.already_member'
    else
      m = Membership.new :from_date => Date.today
      m.group = @group
      m.member = @user

      if m.save
        flash[:notice] = t('group_join_msg')
      end
    end

    redirect_to @group
  end

  def update_memberships_tab_content(memberships, partial_name)
    respond_to do |format|
      format.js { render :partial => 'memberships_tab_change',
                         :locals => {
                             :partial_name => partial_name,
                             :memberships => memberships}
      }
    end
  end

  def get_memberships_tab_content
    @group = Group.includes(:memberships).find(params[:id])
    tab = params[:tab]
    case
      when tab == 'old_memberships'
        partial_name = tab
        memberships = @group.memberships.old.includes(:member).order('members.full_name')
      when tab == 'pending_memberships'
        partial_name = tab
        memberships = @group.memberships.pending.includes(:member).order('created_at desc')
        authorize! :manage, Membership, @group
      else
        partial_name = 'active_memberships'
        memberships = @group.memberships.active.includes(:member).order('members.full_name')
    end

    update_memberships_tab_content(memberships, partial_name)
  end

  def deny_pending_membership
    membership = Membership.find(params[:id])
    group = membership.group
    authorize! :manage, Membership, group
    #todo notification
    membership.delete

    update_memberships_tab_content(group.memberships.pending.includes(:member).order('created_at desc'),
                                   'pending_memberships')
  end

  def accept_pending_membership
    membership = Membership.find(params[:id])
    group = membership.group
    authorize! :manage, Membership, group
    #todo notification
    membership.accepted = true
    membership.save

    update_memberships_tab_content(group.memberships.pending.includes(:member).order('created_at desc'),
                                   'pending_memberships')
  end

  def change_to_old_membership
    membership = Membership.find(params[:id])
    group = membership.group
    authorize! :manage, Membership, group
    membership.to_date = Time.now
    invalidate_posts_and_roles membership

    membership.save

    update_memberships_tab_content(group.memberships.active.includes(:member).order('members.full_name'),
                                   'active_memberships')
  end

  def delete_membership
    membership = Membership.find(params[:id])
    group = membership.group
    authorize! :manage, Membership, group
    membership.to_date = Time.now
    membership.deleted = true
    invalidate_posts_and_roles membership

    membership.save

    update_memberships_tab_content(group.memberships.active.includes(:member).order('members.full_name'),
                                   'active_memberships')
  end

  private
    def invalidate_posts_and_roles(membership)
      membership.member.member_roles.joins(:role).where('roles.group_id' => membership.group.id).destroy_all
      membership.posts.active.map! { |post| post.to = membership.to_date }
    end

end
