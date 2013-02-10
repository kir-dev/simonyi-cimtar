# feleves kovetelmenyek nyilvantartasara
class Admin::SemestersController < ApplicationController

  # GET /admin/semesters
  def index
    @semesters = Semester.limit(20)
    authorize! :manage, Semester
  end

  # GET /admin/semesters/new
  def new
    authorize! :manage, Semester
    @semester = Semester.new
  end

  # POST /admin/semesters
  def create
    authorize! :manage, Semester
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
    authorize! :manage, Semester
  end

  # PUT /admin/semesters/1
  def update
    authorize! :manage, Semester
    @semester = Semester.find params[:id]
    if @semester.update_attributes params[:semester]
      redirect_to admin_semesters_path, :notice => t("messages.semester.successfully_updated")
    else
      render :edit
    end      
  end
end
