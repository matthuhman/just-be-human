class CleanupsController < ApplicationController


  before_action :set_cleanup, only: [:show]


  def new
    @coord_string = params[:coordinates]
    @cleanup = Cleanup.new()
  end



  def create
    coord_string = cleanup_params.extract! :coordinates
    raw_coords = JSON.parse coord_string[:coordinates]
    coords = []
    raw_coords.each do |coord|
      coords.push Coordinate.new(lat: coord['lat'], lng: coord['lng'])
    end
    @cleanup = Cleanup.new(cleanup_params.except(:coordinates))
    @cleanup.user = current_user ? current_user : nil
    @cleanup.latitude = coords.first.lat
    @cleanup.longitude = coords.first.lng

    respond_to do |format|
      binding.pry
      if @cleanup.save
        coords.each do |c|
          c.cleanup = @cleanup
          if !c.save
            format.html {render :new }
            format.json { render json: @role.errors, status: :unprocessable_entity}
          end
        end
        format.html { redirect_to @cleanup, notice: 'Thanks for cleaning up after all of us!' }
        format.json { render :show, status: :created, location: @cleanup }
      else
        format.html {render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity}
      end
    end
  end


  def show
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cleanup
      @cleanup = Cleanup.find(params[:id])
    end


      # Never trust parameters from the scary internet, only allow the white list through.
    def cleanup_params
      params.require(:cleanup).permit(:description, :coordinates, :small_bags, :buckets, :medium_bags, :large_bags, :participants)
    end
end
