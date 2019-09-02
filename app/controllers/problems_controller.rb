class ProblemsController < ApplicationController
  respond_to :html, :xml, :json


  before_action :set_problem, only: [:show, :edit, :update, :destroy, :followers]
  before_action :authenticate_user!, except: [:show]

  before_action :set_time_options, only: [:create, :edit, :new]


  # GET /problems/1
  # GET /problems/1.json
  def show

    if current_user
      @role = ProblemRole.find_by(user_id: current_user.id, problem_id: @problem.id)
      @is_mod = @problem.user_has_mod_permissions(current_user.id)
      @is_admin = @problem.user_is_admin(current_user.id)
    end

    # binding.pry
  end

  # GET /problems/new
  def new
    @problem = Problem.new
    @categories = Category.problem_titles
  end

  # GET /problems/1/edit
  def edit
  end


  # POST /problems
  # POST /problems.json
  def create
    @categories = Category.problem_titles
    @problem = Problem.new(problem_params)
    @problem.user = current_user

    if !@problem.postal_code.empty?
      geopoint = Geopoint.find_by(zip: @problem.postal_code)
      if geopoint
        @problem.latitude = geopoint.latitude
        @problem.longitude = geopoint.longitude
      else
        puts "GEOPOINT NOT FOUND FOR POSTCODE: #{@problem.postal_code}"
      end
    end

    @role = ProblemRole.create
    @role.user_id = current_user.id
    @role.level = 1
    @role.title = "Leader"

    respond_to do |format|
      if @problem.save
        @role.problem_id = @problem.id
        if @role.save
          format.html { redirect_to @problem, notice: 'Problem and role was successfully created.' }
          format.json { render :show, status: :created, location: @problem }
        else
          format.html {render :new }
          format.json { render json: @role.errors, status: :unprocessable_entity}
        end
      else
        format.html { render :new }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /problems/1
  # PATCH/PUT /problems/1.json
  def update
    @categories = Category.problem_titles
    respond_to do |format|
      if @problem.update(problem_params)
        format.html { redirect_to @problem, notice: 'Problem was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem }
      else
        format.html { render :edit }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /problems/1
  # DELETE /problems/1.json
  def destroy
    @problem.destroy
    respond_to do |format|
      format.html { redirect_to problems_url, notice: 'Problem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def followers
    @role = ProblemRole.find_by(user_id: current_user.id, problem_id: @problem.id)
    @is_admin = @problem.user_is_admin(current_user.id)
    respond_modal_with @post, @is_admin, {}, { title: 'hello' }
  end

  #
  # GET /problems/follow
  def follow
    @problem = Problem.find(params[:problem_id])

    respond_to do |format|
      if Role.follow_problem(current_user.id, @problem.id)
        format.html { redirect_to @problem, notice: 'You have successfully followed this problem.' }
        format.json { render :show, status: :created, location: @problem }
      else
        format.html { redirect_to @problem, notice: 'You have not followed this problem successfully' }
        format.json { render :show, status: :unprocessable_entity, location: @problem }
      end
    end
  end

  def volunteer
    @problem = Problem.find(params[:problem_id])
    req_id = 1## @arren fix this
    respond_to do |format|
      if Role.volunteer(current_user.id, req_id, @problem.id)
        format.html { redirect_to @problem, notice: 'You have volunteered!' }
        format.json { render :show, status: :created, location: @problem }
      else
        format.html { redirect_to @problem, notice: 'You have not volunteered for this problem successfully' }
        format.json { render :show, status: :unprocessable_entity, location: @problem }
      end
    end
  end


  #
  # GET /problems/unfollow
  def unfollow
    @problem = Problem.find(unfollow_params[:problem_id])

    respond_to do |format|
      if (Role.unfollow_problem(current_user.id, @problem.id))
        format.html { redirect_to @problem, notice: "You have unfollowed this problem" }
        format.json { render :show, status: :ok, location: @problem}
      else
        format.html { redirect_to @problem, alert: "You cannot unfollow a problem without a role."}
        format.json { render :show, status: :unprocessable_entity, location: @problem}
      end
    end
  end


  #
  #
  def promote_user
    @problem = Problem.find(promotion_params[:problem_id])
    respond_to do |format|
      if (current_user == @problem.user)
        if Role.make_supervisor(params[:target_user_id], @problem.id)
          format.html { redirect_to @problem, notice: "User promoted to Supervisor." }
          format.json { render :show, status: :ok, location: @problem}
        elses
          format.html { redirect_to @problem, notice: "User was not promoted due to an internal error. It has been logged for investigation." }
          format.json { render :show, status: :unprocessable_entity, location: @problem}
        end
      else
        format.html { redirect_to @problem, alert: "You do not have administrative permissions for this problem."}
        format.json { render :show, status: :forbidden, location: @problem }
      end
    end
  end

  def demote_user
    @problem = Problem.find(promotion_params[:problem_id])
    target_user_id = promotion_params[:target_user_id]

    respond_to do |format|
      if (current_user == @problem.user || current_user == target_user_id)
        ## remove the target user as a supervisor
        if Role.remove_supervisor(target_user_id, @problem.id)
            if (target_user_id != current_user.id)
              format.html { redirect_to @problem, notice: "User is no longer a Supervisor." }
              format.json { render :show, status: :ok, location: @problem}
            else
              format.html { redirect_to @problem, notice: "You have stepped down as a Supervisor." }
              format.json { render :show, status: :ok, location: @problem}
            end
        else
          format.html { redirect_to @problem, alert: "User was not demoted due to an internal error. It has been logged for investigation." }
          format.json { render :show, status: :unprocessable_entity, location: @problem }
        end
      else
        format.html { redirect_to @problem, alert: "You do not have administrative permissions for this problem."}
        format.json { render :show, status: :forbidden, location: @problem }
      end
    end
  end





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_params
      params.require(:problem).permit(:title, :description, :category, :planned, :address, :target_completion_date, :postal_code, :country, :volunteers_required)
    end

    def follow_params
      params.permit(:problem_id)
    end

    def unfollow_params
      params.permit(:problem_id)
    end

    def promotion_params
      params.permit(:problem_id, :target_user_id)
    end

    def set_time_options
      @time_options = ["Weekly", "Bi-weekly", "Monthly", "Annually"]
    end
    # def add_follower_role
    #   role = Role.new
    #   return role
    # end
end
