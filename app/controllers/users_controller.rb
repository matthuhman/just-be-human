class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    
    # zipcode = Zipcode.find_by_code @user.zip

    # if zipcode.blank?
    #   format.html { render :new }
    #   format.json { render json: @user, status: :unprocessable_entity }
    # end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to '/', alert: 'Your account was successfully deleted.' }
      format.json { head :no_content }
    end
  end


  ## POST /contact/request
  def request_contact_info
    requesting_user = User.find(contact_params[:requesting_user_id])
    requested_id = contact_params[:requested_user_id]
    share_problem = Problem.users_are_volunteers(requesting_user.id, requested_user.id)
    respond_to do |format|
      if (current_user == requesting_user && share_problem && requesting_user.over_16? && requested_user.over_16?)
        @request = ContactRequest.new(contact_params)
        if @request.save
          format.html { redirect_to requested_user, notice: "You have requested #{requested_id.username}'s contact information. You will be notified via email if they accept" }
          format.json { render :show, status: :created, location: requested_user }
        else
          ReportedError.report("User.request_contact_info", @request.errors, 1000)
          format.html { redirect_to requested_user, alert: "An unexpected error occurred when issuing this contact request. The error has been logged for investigation." }
          format.json { render :show, status: :unprocessable_entity, location: requested_user }
        end
      else
        if current_user != requesting_user || !share_problem
          format.html { redirect_to requested_user, alert: "You do not have permission to request this user's contact information" }
          format.json { render :show, status: :forbidden, location: requested_user }
        elsif !requesting_user.over_16?
          format.html { redirect_to requested_user, alert: "You must be over 16 to request another user's contact information." }
          format.json { render :show, status: :forbidden, location: requested_user }
        end
      end
    end
  end


  ## POST /contact/response
  def respond_contact_info
    request = ContactRequest.find(contact_response_params[:id])
    accept = contact_response_params[:accept]
    requesting_user = User.find(request.requesting_user_id)

    respond_to do |format|
      if current_user.id == request.requested_user_id
        if accept
          request.active = true
          request.accepted = true
          request.accept_time = Date.today
        else
          request.active = true
          request.accepted = false
        end

        if request.save 
          if request.accepted
            respond.html { redirect_to current_user, notice: "You have accepted the contact request from #{requesting_user.username}- they will be notified via email." }
            respond.json { render :show, status: :accepted, location: current_user }
          else
            respond.html { redirect_to current_user, alert: "You have declined to share contact information with #{requesting_user.username}. They will not be notified, and you will automatically decline all future requests from this user." }
            respond.json { render :show, status: :accepted, location: current_user }
          end
        else
          ReportedError.report("User.repond_contact_info", request.errors, 1000)
          respond.html { redirect_to current_user, alert: "An unexpected error occurred when responding to this contact request. The error has been logged for investigation." }
          respond.json { render :show, status: :unprocessable_entity, location: current_user }
        end
      else
        format.html { redirect_to current_user, alert: "You do not have permissions on this object." }
        format.json { render :show, status: :forbidden, location: current_user }
      end
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :email, :city, :state, :zip, :country)
    end

    def contact_params
      params.require(:contact_request).(:requesting_user_id, :requested_user_id)
    end

    def contact_response_params
      params.require(:contact_response).(:id, :accept)
    end
end
