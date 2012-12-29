class GroupsController < ApplicationController
  helper_method :is_member_in_group

  # GET /groups
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /groups/1
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /groups/new
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  def create
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

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # obsolete use group#has_member? instead
  def is_member_in_group(group, member, accepted)
    if accepted.nil?
      0 < Membership.where(:group_id => group.id,
                           :member_id => member.id,
                           :to_date => nil).count
    else
      0 < Membership.where(:group_id => group.id,
                           :member_id => member.id,
                           :to_date => nil,
                           :accepted => accepted).count
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

  # POST /groups/1/leave
  def leave
    @group = Group.find(params[:id])
    if is_member_in_group(@group, @user, true)
      ms = Membership.where(:group_id => @group.id,
                            :member_id => @user.id,
                            :accepted => true).order('from_date DESC').limit(1).first

      ms.to_date = Time.now

      if ms.save
        flash[:success] = t('group_leave_msg')
      else
        flash[:error] = t('group_leave_msg_failed')
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
    @group = Group.find(params[:id])
    tab = params[:tab]
    case
      when tab == 'old_memberships'
        partial_name = tab
        memberships = @group.get_old_memberships
      when tab == 'pending_memberships'
        partial_name = tab
        memberships = @group.get_pending_memberships
      else
        partial_name = 'active_memberships'
        memberships = @group.get_active_memberships
    end

    update_memberships_tab_content(memberships, partial_name)
  end

  def deny_pending_membership
    #todo permission check
    membership = Membership.find(params[:id])
    group = membership.group
    #todo notification
    membership.delete

    update_memberships_tab_content(group.get_pending_memberships,
                                   'pending_memberships')
  end

  def accept_pending_membership
    #todo permission check
    membership = Membership.find(params[:id])
    group = membership.group
    #todo notification
    membership.accepted = true
    membership.save

    update_memberships_tab_content(group.get_pending_memberships,
                                   'pending_memberships')
  end

end
