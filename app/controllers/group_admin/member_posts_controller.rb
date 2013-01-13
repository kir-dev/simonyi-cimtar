class GroupAdmin::MemberPostsController < ApplicationController
  before_filter :setup_resources_for_posts
  before_filter :load_and_authorize_post, only: [ :edit, :update, :destroy ]

  # GET /group_admin/memberships/1/posts
  def index
    @membership = Membership.includes(:posts).find params[:membership_id]
    authorize! :read, MemberPost, @membership.group

  end

  # GET /group_admin/memberships/1/posts/new
  def new
    membership = Membership.find params[:membership_id]
    authorize! :create, MemberPost, membership.group
    authorize! :create, Permission, membership.group
    
    # TODO: predefined stuff
    @post = membership.posts.build
  end

  # POST /group_admin/memberships/1/posts
  def create
    @membership = Membership.find params[:membership_id]

    authorize! :create, MemberPost, @membership.group
    authorize! :update, @membership, @membership.group
    authorize! :create, Permission, @membership.group

    @post = MemberPost.new params[:member_post]
    @post.membership = @membership

    if @post.save
      # redirect to index
      redirect_to group_admin_membership_posts_path(@membership)
    else
      render :new
    end
  end

  # GET /group_admin/memberships/1/posts/1/edit
  def edit
  end

  # PUT /group_admin/memberships/1/posts/1
  def update

    if @post.update_attributes(params[:member_post])
      redirect_to group_admin_membership_posts_path(@post.membership)
    else
      render :edit
    end
  end

  # DELETE /group_admin/memberships/1/posts/1
  def destroy
    authorize! :delete, MemberPost, @post.membership.group

    @post.deleted = true
    if @post.save
      notice = t("messages.successfull_delete")
    else
      notice = t("messages.unsuccessfull_delete")
    end
      redirect_to group_admin_membership_posts_path(@post.membership), notice: notice

  end

private 
  def setup_resources_for_posts
    @resources = {}
    MemberPost::RESOURCES.each do |r|
      @resources[t("resources." + r)] = r
    end
  end

  def load_and_authorize_post
    @post = MemberPost.find params[:id]
    authorize! :update, MemberPost, @post.membership.group
  end
end
