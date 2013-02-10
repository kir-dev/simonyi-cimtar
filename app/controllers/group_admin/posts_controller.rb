class GroupAdmin::PostsController < ApplicationController

  def index
    @group = Group.find(params[:group_id])
    @memberships = @group.memberships.active
  end

  def new
    @post = Post.new
    @membership = Membership.active.where(group_id: params[:group_id], member_id: params[:member_id]).first
  end

  def create
    @post = Post.new params[:post]
    @membership = Membership.find params[:membership_id]
    @post.membership = @membership
    if @post.save
      redirect_to group_admin_posts_path(group_id: @membership.group)
    else
      render :new
    end
  end

  def edit
    @post = Post.active.find params[:id]
    @membership = Membership.active.where(group_id: params[:group_id], member_id: params[:member_id]).first
  end

  def update
    @post = Post.active.find params[:id]
    @membership = @post.membership
    if @post.update_attributes(params[:post])
      redirect_to group_admin_posts_path(group_id: @post.membership.group)
    else
      render :edit
    end
  end

  def destroy
    # TODO: authorize
    post = Post.active.find params[:id]
    post.to = Date.current
    post.save

    redirect_to group_admin_posts_path(group_id: post.membership.group)
  end
end
