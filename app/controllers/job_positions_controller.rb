class JobPositionsController < ApplicationController

  helper_method :is_own_profile?

  def create
    member = Member.find(params[:member_id])
    if @user.id == member.id
      @job_position = JobPosition.new(params[:job_position])
      @job_position.member = member

      respond_to do |format|
        if @job_position.save
          format.js { render :partial => 'create' }
        else
          format.js { render :partial => 'error' }
        end
      end
    end
  end

  def update
    member = Member.find(params[:member_id])
    if @user.id == member.id
      @job_position = JobPosition.find(params[:id])

      respond_to do |format|
        if @job_position.update_attributes(params[:job_position])
          format.json { respond_with_bip(@job_position) }
        else
          format.json { respond_with_bip(@job_position) }
        end
      end
    end
  end

  def destroy
    member = Member.find(params[:member_id])
    if @user.id == member.id
      @job_position = JobPosition.find(params[:id])

      @job_position.destroy

      respond_to do |format|
        if @job_position.destroyed?
          format.js { render :partial => 'create' }
        else
          format.js { render :partial => 'error' }
        end
      end
    end
  end

  def is_own_profile?
    @user.id == @member.id
  end

end
