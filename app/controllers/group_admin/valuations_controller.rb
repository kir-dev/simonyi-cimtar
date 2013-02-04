# for group admin
# only can manage community and professional requirements for the members
class GroupAdmin::ValuationsController < ApplicationController
  before_filter :check_valuation_period

  def index
    # TODO: authorization
    @group = Group.find params[:group_id]
    @members = Membership.includes(:member).active.where(:group_id => params[:group_id]).map { |ms| ms.member }
    @valuations = Semester.current_valuation_period.valuations.where(:member_id => @members)

    @valuations.concat generate_missing_valuations(@members, @valuations)

    @valuations.sort! { |x,y| x.member.name <=> y.member.name }
  end

  def update_multiple
    valuations = Valuation.find params[:valuations].keys
    # TODO: authorization

    # update all validations at once
    valuations.each do |valuation|
      valuation.assign_attributes params[:valuations][valuation.id.to_s]
      # only save the changed records
      if valuation.changed?
        # raise excepteption if validation fails
        valuation.save!
      end
    end
    flash[:success] = t "messages.valuation.successfully_updated"
    redirect_to group_admin_valuations_path(:group_id => params[:group_id])
  end

  private

  def check_valuation_period
    unless valuation_period?
      render "shared/not_valuation_period"
    end
  end

  def generate_missing_valuations(members, valuations)
    missing_valuations = [];

    members.each { |member|
      found = false
      valuations.each { |val|
        if val.member_id == member.id
          found = true
          break
        end
      }

      unless found
        new_valuation = Valuation.new
        new_valuation.semester = Semester.current_valuation_period
        new_valuation.member = member
        new_valuation.scholarship_index = 0.0
        new_valuation.save
        missing_valuations.push(new_valuation)
      end
    }

    missing_valuations
  end
end
