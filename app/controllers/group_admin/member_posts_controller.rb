class GroupAdmin::MemberPostsController < ApplicationController

  # GET /group_admin/posts/new
  def new
    # TODO: predefined stuff
    @post = MemberPost.new
  end

  # POST /group_admin/posts
  def create
    @membership = Membership.find params[:membership_id]

    # TODO: authorize
    #authorize! :create, MemberPost
    #authorize! :update, @membership
    @post = MemberPost.create_from_params params[:member_post]
    @post.membership = @membership

    if @post.save
      redirect_to :root
    else
      render :new
    end
  end
end
