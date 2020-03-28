class WaiversController < ApplicationController

  before_action :authenticate_user!
  before_action :set_waiver, except: [:new, :create]

  def create
    #oppo = Opportunity.find(waiver_params[:opportunity_id])
    oppo_id = waiver_params.delete :opportunity_id
    params = waiver_params.except :opportunity_id
    binding.pry

    @waiver = Waiver.new(params)
    @waiver.user = current_user
    @waiver.state_code = current_user.region
    file = waiver_params[:waiver_file]

    @waiver.file_name = file.original_filename
    @waiver.file_type = file.content_type

    if @waiver.file_type != 'application/pdf'
      redirect_to new_waiver_path, alert: "Waivers must be in PDF form"
    else
      if @waiver.save
        if oppo_id && !oppo_id.empty?
          oppo = Opportunity.find(oppo_id)
          if oppo
            oppo_waiver = OpportunityWaiver.new(waiver: @waiver, opportunity: oppo)
            if oppo_waiver.save
              redirect_to oppo, notice: "Waiver uploaded successfully and associated with your cleanup!"
            else
              @waiver.destroy
              ReportedError.report("OppoWaiver.create", oppo_waiver.errors, 100)
              redirect_to new_waiver_path, alert: "There was an error while associating your waiver."
            end
          else
            redirect_to '/', notice: @waiver.file_name + ' has been uploaded successfully'
          end
        else
          redirect_to '/', notice: @waiver.file_name + ' has been uploaded successfully.'
        end
      else
        ReportedError.report('WaiverController.create', @waiver.errors, 1000)
        redirect_to new_waiver_path(@waiver), alert: 'Waiver was not uploaded correctly. The error has been logged for investigation.'
      end
    end
  end

  def new
    @opp_id = new_waiver_param[:opportunity_id]
    @waiver = Waiver.new()
  end

  def show
  end

  def edit
  end

  def destroy
    oppo = @waiver.opportunity
    if current_user == @waiver.user
      if @waiver.destroy
        redirect_to oppo, notice: 'Waiver was deleted successfully'
      else
        ReportedError.report('WaiverController.destroy', @waiver.errors, 1000)
      end
    else
      redirect_to oppo, notice: 'You do not have permission to delete this waiver'
    end
  end



  private

    def set_waiver
      @waiver = Waiver.find(params[:id])
    end

    def waiver_params
      params.require(:waiver).permit(:parent_waiver_id, #
        :opportunity_id, :location, :waiver_file, :is_public, :is_general_purpose, #
        :is_official, :title, :description)
    end

    def new_waiver_param
      params.permit(:opportunity_id)
    end
end
