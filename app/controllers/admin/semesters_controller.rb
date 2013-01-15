# feleves kovetelmenyek nyilvantartasara
class Admin::SemestersController < ApplicationController

  # GET /admin/semesters
  def index
    @semesters = Semester.limit(20)
    authorize! :read, @semesters
  end

  # GET /admin/semesters/new
  def new
    authorize! :create, Semester
    @semester = Semester.new
  end

  # POST /admin/semesters
  def create
    authorize! :create, Semester
    @semester = Semester.new params[:semester]

    if @semester.save
      redirect_to admin_semesters_path, :notice => t("messages.semester.successfully_created")
    else
      render :new
    end
  end

  # GET /admin/semesters/1
  def edit
    @semester = Semester.find params[:id]
    authorize! :update, @semester
  end

  # PUT /admin/semesters/1
  def update
    @semester = Semester.find params[:id]
    if @semester.update_attributes params[:semester]
      redirect_to admin_semesters_path, :notice => t("messages.semester.successfully_updated")
    else
      render :edit
    end      
  end
end
