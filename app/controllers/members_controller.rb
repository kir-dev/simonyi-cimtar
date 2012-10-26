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

  # POST /members
  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: 'Member was successfully created.' }
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
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { respond_with_bip(@member) }
      else
        format.html { render action: "edit" }
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
end
