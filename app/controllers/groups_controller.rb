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

  def is_member_in_group(group, member)
    0 < Membership.where(:group_id => group.id, :member_id => member.id).count
  end

  def join
    @group = Group.find(params[:id])
    Membership.new(:group_id => @group.id,
                   :member_id => @user.id,
                   :from => Date.current,
                   :accepted => false).save

    redirect_to @group
  end
end
