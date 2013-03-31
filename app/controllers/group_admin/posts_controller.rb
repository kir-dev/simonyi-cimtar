class GroupAdmin::PostsController < ApplicationController

  def index
    @group = Group.find(params[:group_id])
    authorize! :manage, Post, @group
    @memberships = @group.memberships.active
  end

  def new
    @post = Post.new
    @membership = Membership.active.where(group_id: params[:group_id], member_id: params[:member_id]).first
  end

  def create
    @post = Post.new params[:post]
    @membership = Membership.find params[:membership_id]
    authorize! :manage, Post, @membership.group
    @post.membership = @membership

    unless params[:post][:old_post] == '1'
      @post.to = nil
    end

    if @post.save
      redirect_to group_admin_posts_path(group_id: @membership.group)
    else
      render :new
    end
  end

  def edit
    authorize! :manage, Post, Group.find(params[:group_id])
    @post = Post.active.find params[:id]
    @membership = Membership.active.where(group_id: params[:group_id], member_id: params[:member_id]).first
  end

  def update
    @post = Post.active.find params[:id]
    authorize! :manage, Post, @post.membership.group
    @membership = @post.membership
    if @post.update_attributes(params[:post])
      redirect_to group_admin_posts_path(group_id: @post.membership.group)
    else
      render :edit
    end
  end

  def destroy
    post = Post.active.find params[:id]
    authorize! :manage, Post, post.membership.group
    post.to = Date.current
    post.save

    redirect_to group_admin_posts_path(group_id: post.membership.group)
  end
end
