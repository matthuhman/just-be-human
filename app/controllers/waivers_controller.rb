class WaiversController < ApplicationController

  before_action :authenticate_user!
  before_action :set_waiver

  def create
    @waiver = Waiver.new(waiver_params)
    @waiver.user = current_user
    if @waiver.save
      redirect_to @waiver.opportunity, notice: @waiver.fileName + ' has been uploaded successfully'
    else
      ReportedError.report('WaiverController.create', @waiver.errors, 1000)
      redirect_to @waiver.opportunity, alert: 'Waiver was not uploaded correctly. The error has been logged for investigation.'
    end
  end

  def new
    @waiver = Waiver.new
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
end
