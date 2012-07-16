#@author: Marina Charles
#@Author: Doha
class CommentsController < ApplicationController


  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  #Author: Doha
  #This action is to create a comment in the need's page, by passing the certain need's ID, and the customer commented ID.
  #@need => gets the need ID, that the comment will be posted on
  #@comment => gets the specific comment on the specified need (by calling it on its ID).
  def create
    @need = Need.find(params[:need_id])
    @comment = @need.comments.build(params[:comment])
    @customer = Customer.find(current_customer.id)
    @comment.update_attributes(:customer => @customer)
    if current_customer != nil
      @banned_customer = Customer.is_banned(current_customer.id)
      @needer = @need.is_needer(current_customer)
    end
     respond_to do |format|
      if @comment.save
        format.js
      elsif blank
        redirect_to :back
      else 
        format.html
        format.js 
      end
    end 
  end

  # PUT /comments/1
  # PUT /comments/1.json
  #this update is not used.
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  #@Author: Nisma El-Nayeb
  #@Summary: action for liking a comment
  #@ParamName: "comment" => the comment that the current_customer wants to like
  #@ParamName: "current_customer" => the current_customer who likes a comment
  #@ParamName: ":up" => indication that the user is voting up as opposed to voting 
  #            down(dislike)
  def like
    comment = Comment.find(params[:comment])
    current_customer.vote(comment, :up)
    @need = comment.need
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
      format.js
    end
  end

  #@Author: Nisma El-Nayeb
  #@Summary: action for disliking a comment
  #@ParamName: "comment" => the comment that the current_customer wants to dislike
  #@ParamName: "current_customer" => the current_customer who dislikes a comment
  #@ParamName: ":down" => indication that the user is voting down as opposed to voting 
  #            up(like)
  def dislike
    comment = Comment.find(params[:comment])
    current_customer.vote(comment, :down)
    @need = comment.need
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
      format.js
    end
  end

  #@Author: Nisma El-Nayeb
  #@Summary: action for undoing liking or disliking a comment
  #@ParamName: "comment" => the comment that the current_customer wants to remove his/her
  #            vote from.
  #@ParamName: "current_customer" => the current_customer who wants to remove his/her
  #            vote.
  def unlike
    comment = Comment.find(params[:comment])
    current_customer.unvote(comment)
    @need = comment.need
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
      format.js
    end
  end
  
#@author: Marina Charles
#@summary: in this action, i get the comment that i want to delete and in customer/needs/_comment_partial.haml exists the button and the notice that makes the customer confirm that he wants to delete his comment(only the one who made the comment can delete it)
#@comment: "id" => get the comment with the following id

  def destroy
    need_id = Comment.find(params[:id]).need.id
    @comment = Comment.find(params[:id])
    @comment.destroy
    @need = Need.find(need_id)


    respond_to do |format|
      format.html { redirect_to :back}
      format.json { head :no_content }
      format.js
    end
  end
 


 

end
