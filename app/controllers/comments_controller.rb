class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]


  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    problem_id = params[:comment][:problem_id]
    milestone_id = params[:comment][:milestone_id]
    
    

    if problem_id != nil
      params[:comment] = params[:comment].merge(:commentable_type => "Problem", :commentable_id => problem_id)
      params[:comment] = params[:comment].except(:problem_id)
    elsif milestone_id != nil
      params[:comment] = params[:comment].merge(:commentable_type => "Milestone", :commentable_id => milestone_id)
      params[:comment] = params[:comment].except(:milestone_id)
    end

    @comment = Comment.new(comment_params)
    
    @comment.user_id = current_user.id

    problem = Problem.find(problem_id)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to problem, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    if @comment.commentable_type == "Problem"
      @parent = Problem.find(@comment.commentable_id)
    else
      @parent = Milestone.find(@comment.commentable_id)
    end
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @parent, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @parent }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if @comment.commentable_type == "Problem"
      @parent = Problem.find(@comment.commentable_id)
    else
      @parent = Milestone.find(@comment.commentable_id)
    end
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @parent, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :commentable_type, :commentable_id)
    end
end
