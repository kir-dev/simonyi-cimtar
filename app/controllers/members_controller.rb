class MembersController < ApplicationController
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

  # GET /members/1/edit
  def edit
    @member = Member.find(params[:id])
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
      else
        format.html { render action: "edit" }
      end
    end
  end
end
