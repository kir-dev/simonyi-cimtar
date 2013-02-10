class MembersController < ApplicationController
  layout 'logout', :only => :logout

  helper_method :is_own_profile?

  # GET /members
  def index
    @members = Member.all
    authorize! :manage, Member

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /members/1
  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /members/new
  def new
    @member = Member.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /members/reg
  def reg_with_sso
    @member = Member.find_by_login(remote_user)

    if @member.nil? # reg with sso, not saved / imported yet
      @member = Member.new
      set_attributes @member
    else
      @member.last_active = Time.now
    end

    respond_to do |format|
      format.html { render action: "new" }
    end
  end

  # POST /members
  def create
    if @user.nil? # current user is not in the db, creates himself
      @member = Member.new(params[:member].except(:login).except(:join_groups))
      @member.set_login_attr(get_attribute_value(:login))
      @member.last_active = Time.now

      params[:member][:join_groups].each { |group_id|
        if !group_id.blank? and group_id.to_i > 0
          group = Group.find(group_id)
          unless group.nil?
            ms = Membership.new
            ms.group = group
            ms.member = @member
            ms.accepted = false
            ms.from_date = Time.now

            @member.memberships.push ms
          end
        end
      }
    end

    respond_to do |format|
      if @member.memberships.empty?
        @member.errors.add(:join_groups, t('activerecord.errors.models.member.attributes.join_groups.empty'))
        format.html { render action: "new" }
      else
        if @member.save
          format.html { redirect_to @member, notice: t('reg_success') }
        else
          format.html { render action: "new" }
        end
      end
    end
  end

  # PUT /members/1
  def update
    @member = Member.find(params[:id])

    if is_own_profile? # update only himself
      respond_to do |format|
        if @member.update_attributes(params[:member])
          format.html { redirect_to @member }
          format.json { respond_with_bip(@member) }
        else
          format.html { render :edit }
          format.json { respond_with_bip(@member) }
        end
      end
    end
  end

  # GET /logout
  def logout
    if !remote_user.nil? and !remote_user.empty?
      #redirect to shib logout
      redirect_to Rails.application.config.logout_url
    end
  end

  def wait_for_accept
    respond_to do |format|
      format.html { render action: "wait_for_accept" }
    end
  end

  def is_own_profile?
    @user.id == @member.id
  end
end
