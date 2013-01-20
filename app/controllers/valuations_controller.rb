# for members to edit their scholarship index
class ValuationsController < ApplicationController

  before_filter :load_semester
  before_filter :load_valuation, :only => [:edit, :update]

  # GET /member/1/valuation/new
  # new action creates a new valuation if not exsits and redericest to edit
  def new
    # find the valuation for the member and given valuation period
    valuation = Valuation.where(:member_id => params[:member_id], :semester_id => @semester).first
    if valuation
      authorize! :update, valuation
    else
      authorize! :create, Valuation
      valuation = Valuation.new :scholarship_index => 0.0
      valuation.member_id = params[:member_id]
      valuation.semester = @semester
      valuation.save
    end

    redirect_to edit_member_valuation_path(params[:member_id], valuation)
  end

  def edit
    authorize! :update, @valuation
  end

  def update
    authorize! :update, @valuation
    @valuation.scholarship_index = params[:valuation][:scholarship_index]
    if @valuation.save
      flash[:success] = t("messages.valuation.successfully_updated")
      redirect_to edit_member_valuation_path(params[:member_id], @valuation)
    else
      render :edit
    end
  end

private
  def load_semester
    @semester = Semester.current_valuation_period
    render "shared/not_valuation_period" if @semester.blank?
  end

  def load_valuation
    # @member = Member.find params[:member_id]
    @valuation = Valuation.find params[:id]
  end
end
