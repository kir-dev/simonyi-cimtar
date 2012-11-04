class JobPositionsController < ApplicationController

  #TODO: could be deleted?
  def show
    @job = JobPosition.find(params[:id])

    respond_to do |format|
      format.js
      format.json { render :json => @job }
    end
  end

  def create
    @job_position = JobPosition.new(params[:job_position])
    @job_position.member = Member.find(params[:member_id])

    respond_to do |format|
      if @job_position.save
        format.js { render :partial => 'create' }
      else
        format.js { render :partial => 'error' }
      end
    end
  end

  def update
    @job_position = JobPosition.find(params[:id])

    respond_to do |format|
      if @job_position.update_attributes(params[:job_position])
        format.json { respond_with_bip(@job_position) }
      else
        format.json { respond_with_bip(@job_position) }
      end
    end
  end

  def destroy
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
