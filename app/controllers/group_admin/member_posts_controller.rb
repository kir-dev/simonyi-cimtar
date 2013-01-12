class GroupAdmin::MemberPostsController < ApplicationController
  before_filter :setup_resources_for_posts

  # GET /group_admin/memberships/1/posts
  def index
    @membership = Membership.includes(:posts).find params[:membership_id]
    authorize! :read, MemberPost, @membership.group

  end

  # GET /group_admin/memberships/1/posts/new
  def new
    membership = Membership.find params[:membership_id]
    authorize! :create, MemberPost, membership.group
    
    # TODO: predefined stuff
    @post = membership.posts.build
  end

  # POST /group_admin/memberships/1/posts
  def create
    @membership = Membership.find params[:membership_id]

    authorize! :create, MemberPost, @membership.group
    authorize! :update, @membership
    @post = MemberPost.create_from_params params[:member_post]
    @post.membership = @membership

    if @post.save
      # redirect to index
      redirect_to group_admin_membership_posts_path(@membership)
    else
      render :new
    end
  end

private 
  def setup_resources_for_posts
    @resources = {}
    MemberPost::RESOURCES.each do |r|
      @resources[t("resources." + r)] = r
    end
    
  end
end
