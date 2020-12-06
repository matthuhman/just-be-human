class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!


##################################################
#####################
#####################
#####################
#####################
##################### =>  20201205 abandoned
#####################
#####################
#####################
#####################
#####################
##################################################




  # # GET /comments/new
  # def new
  #   @comment = Comment.new
  # end

  # # GET /comments/1/edit
  # def edit
  #   @post = Post.find(@comment.post_id)
  # end

  # # POST /comments
  # # POST /comments.json
  # def create
  #   @comment = Comment.new(comment_params)
  #   @comment.user_id = current_user.id
  #   @post = Post.find(@comment.post_id) if @comment.post_id?

  #   oppo = @post.opportunity
  #   respond_to do |format|
  #     if comment_params[:content] && !comment_params[:content].empty?
  #       if current_user.is_follower?(oppo.id)

  #         if @comment.save
  #           format.html { redirect_to @post, notice: 'Comment was successfully created.' }
  #           format.json { render :show, status: :created, location: @post }
  #         else
  #           format.html { render :new, post_id: @comment.post_id }
  #           format.json { render json: @comment.errors, status: :unprocessable_entity }
  #         end
  #       else
  #         format.html { redirect_to @post, alert: 'You do not have permission to comment on this post. You must follow the opportunity first!' }
  #         format.json { render :show, status: :forbidden, location: @post }
  #       end
  #     else
  #       @comment.errors.add(:content, "Content cannot be empty")
  #       format.html { render :new }
  #       format.json { render json: @comment.errors, status: :bad_request }
  #     end
  #   end
  # end

  # # PATCH/PUT /comments/1
  # # PATCH/PUT /comments/1.json
  # def update
  #   @post = Post.find(@comment.post_id)
  #   respond_to do |format|
  #     if (current_user.id == @comment.user_id)
  #       if @comment.update(comment_params)
  #         format.html { redirect_to @post, notice: 'Comment was successfully updated.' }
  #         format.json { render :show, status: :ok, location: @post }
  #       else
  #         format.html { render :edit }
  #         format.json { render json: @comment.errors, status: :unprocessable_entity }
  #       end
  #     else
  #       format.html { redirect_to @post, alert: 'You do not have permissions to edit this comment.' }
  #       format.json { render :show, status: :forbidden, location: @post }
  #     end
  #   end
  # end

  # # DELETE /comments/1
  # # DELETE /comments/1.json
  # def destroy
  #   @post = Post.find(@comment.post_id)
  #   @comment.destroy
  #   respond_to do |format|
  #     format.html { redirect_to @post, notice: 'Comment was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
