class MembersController < ApplicationController
  layout 'logout', :only => :logout

  # GET /members
  def index
    @members = Member.all

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
    if @user.nil? # registration with sso, or first login
      @member = Member.new(params[:member].except(:login))
      @member.set_login_attr(get_attribute_value(:login))
      @member.last_active = Time.now
    else
      if @user.admin?
        @member = Member.new(params[:member])
      end
    end

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: t('reg_success') }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /members/1
  def update
    @member = Member.find(params[:id])

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
end
