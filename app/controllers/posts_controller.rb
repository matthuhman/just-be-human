class PostsController < ApplicationController
  respond_to :html, :xml, :json

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    if @post.postable_type == 'Opportunity'
      @parent = Opportunity.find(@post.postable_id)
    else
      @parent = Requirement.find(@post.postable_id)
    end
    respond_modal_with @post
  end

  # GET /posts/new
  def new
    @post = Post.new
    respond_modal_with @post
  end

  # GET /posts/1/edit
  def edit
    respond_modal_with @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    if @post.postable_type == 'Opportunity'
      @parent = Opportunity.find(@post.postable_id)
      level = Role.opportunity_role_level(current_user.id, @post.postable_id)
    else
      @parent = Requirement.find(@post.postable_id)
      level = Role.requirement_role_level(current_user.id, @post.postable_id)
    end

    @post.user_id = current_user.id

    respond_to do |format|
      if level
        if @post.save
          format.html { redirect_to @parent, notice: 'Post was successfully created.' }
          format.json { render :show, status: :created, location: @parent }
        else
          format.html { render :new }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @parent, alert: 'You do not have permission to make a post on this opportunity/requirement' }
        format.json { render :show, status: :forbidden, location: @parent }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.user_has_permissions(current_user.id)
        if @post.update(post_params)
          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @post, alert: 'You do not have permissions to delete this post' }
        format.json { render :show, status: :forbidden, location: @parent }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if @post.postable_type == "Opportunity"
      @parent = Opportunity.find(@post.postable_id)
    else
      @parent = Requirement.find(@post.postable_id)
    end

    respond_to do |format|
      if @post.user_has_permissions(current_user.id)
        @post.destroy
        format.html { redirect_to @parent, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @parent, alert: 'You do not have permissions to delete this post' }
        format.json { render :show, status: :forbidden, location: @post }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :content, :postable_id, :postable_type)
  end
end
