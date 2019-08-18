class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]


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
    @sub_categories = Category.get_all_problem_subcats
  end

  # GET /problems/1/edit
  def edit
  end

  # POST /problems
  # POST /problems.json
  def create
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
          format.html {render :new}
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


  # GET /problems/follow
  def follow
    @problem = Problem.find(params[:problem_id])
    @role = Role.create(follow_params)
    @role.title = "Follower"
    @role.level = 4
    @role.user_id = current_user.id
    respond_to do |format|
      if @role.save
        Problem.increment_counter(:follower_count, @problem.id)
        format.html { redirect_to @problem, notice: 'You have successfully followed this problem.' }
        format.json { render :show, status: :created, location: @problem }
      else
        format.html { redirect_to @problem, notice: 'You have not followed this problem successfully' }
        format.json { render :show, status: :unprocessable_entity, location: @problem }
      end
    end
  end

  def promote_user
    @problem = Problem.find(promotion_params[:problem_id])
    respond_to do |format|
      if (current_user == @problem.user)
        @role = Role.find_by(user_id: promotion_params[:target_user_id], problem_id: @problem.id)
        if @role
          if (@role.level == 4)
            increment_participant_count = true
          end
          @role.level = 2
          @role.title = "Supervisor"
          if @role.save
            if increment_participant_count
              Problem.increment_counter(:participant_count, @problem.id)
            end
            format.html { redirect_to @problem, notice: "You have promoted #{@role.user.username} to Supervisor." }
            format.json { render :show, status: :ok, location: @problem}
          else
            format.html { redirect_to @problem, notice: "#{@role.user.username} was not successfully promoted due to an internal error." }
            format.json { render :show, status: :unprocessable_entity, location: @problem}
          end
        else
          format.html { redirect_to @problem, alert: "A role does not exist for the desired user/problem ID combo" }
          format.json { render :show, status: :unprocessable_entity, location: @problem }
        end
      else
        format.html { redirect_to @problem, alert: "You do not have administrative permissions for this problem."}
        format.json { render :show, status: :forbidden, location: @problem }
      end
    end
  end

  def demote_user
    @problem = Problem.find(promotion_params[:problem_id])
    target_user = User.find(promotion_params[:target_user_id])
    @role = Role.find_by(user_id: promotion_params[:target_user_id], problem_id: @problem.id)
    respond_to do |format|
      if (current_user == @problem.user || current_user == @role.user)
        if @role
          target_user.milestone_roles do |ms_role|
            if ms_role.problem_id == @problem.id
              @role.level = 3
              @role.title = "Participant"
            else
              @role.level = 4
              @role.title = "Follower"
            end
          end
          if @role.save
            if (@role.level == 4)
              Problem.decrement_counter(:participant_count, @problem.id)
            end
            if (@role.user != current_user)
              format.html { redirect_to @problem, notice: "You have demoted #{@role.user.username} to Follower." }
              format.json { render :show, status: :ok, location: @problem}
            else
              format.html { redirect_to @problem, notice: "You have stepped down as a Supervisor." }
              format.json { render :show, status: :ok, location: @problem}
            end
          else
            format.html { redirect_to @problem, notice: "#{@role.user.username} was not successfully demoted due to an internal error." }
            format.json { render :show, status: :unprocessable_entity, location: @problem }
          end
        else
          format.html { redirect_to @problem, alert: "A role does not exist for the desired user/problem ID combo" }
          format.json { render :show, status: :unprocessable_entity, location: @problem }
        end
      else
        format.html { redirect_to @problem, alert: "You do not have administrative permissions for this problem."}
        format.json { render :show, status: :forbidden, location: @problem }
      end
    end
  end



  def unfollow
    @problem = Problem.find(unfollow_params[:problem_id])

    @role = Role.find_by(user_id: current_user.id, problem_id: params[:problem_id])
    respond_to do |format|
      if (@role)
        @role.destroy
        Problem.decrement_counter(:follower_count, @problem.id)
        format.html { redirect_to @problem, notice: "You have unfollowed this problem" }
        format.json { render :show, status: :ok, location: @problem}
      else
        format.html { redirect_to @problem, alert: "You cannot unfollow a problem without a role."}
        format.json { render :show, status: :unprocessable_entity, location: @problem}
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
      params.require(:problem).permit(:title, :description, :category, :subcategory, :address, :target_completion_date, :postal_code, :country, :participants_required)
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

    # def add_follower_role
    #   role = Role.new
    #   return role
    # end

end
