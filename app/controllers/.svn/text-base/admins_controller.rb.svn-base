#@Author = Alaa Shafaee
#@Author = Nada Nasr
class AdminsController < ApplicationController
  
  before_filter :authenticate_admin!

  require 'will_paginate/array'

  layout 'admin'
  # @Author: Alaa Shafaee
  # @summary: returns a list of all admins.
  # @paramName: params[:page] => passes the page for pagination.
  def index
    @admins = Admin.get_admins(params[:page])
  end
  
  # @Author: Alaa Shafaee
  # @summary: deletes the admin passed in the hash params. A success notice is added to be displayed in the view.
  #           The action is called when the delete button in admins/index view is clicked.
  def destroy
    Admin.destroy_admin(params[:id])
    respond_to do |format|
      format.html { redirect_to admins_path, notice: 'Admin was successfully deleted.' }
    end
  end
#@author:Mohamed Osama
#@summary:make a list of reported needs and comments excluding the hidden and deleted ones
  def reported
    @reported_needs = (Need.where(reported: true).excludes(deleted: true) - Need.any_in(_id: Admin.find(current_admin.id).hidden_needs)).paginate :order=>'created_at desc', :per_page=>10, :page => params[:reported_needs]
    @reported_comments = (Comment.where(reported: true).excludes(deleted: true) - Comment.any_in(_id: Admin.find(current_admin.id).hidden_comments)).paginate :order=>'created_at desc', :per_page=>10, :page => params[:reported_comments] 

  end

  # @Author: Nada Nasr
  # @Summary: hides the marked comments from the admin's view by calling the action 
  #           hide_comments(comments_to_hide) in the model
  # @paramName: params[:comment_ids] => ids of comments the admin wants hidden
  def hide_marked_comments
    Admin.find(current_admin.id).hide_comments(params[:comment_ids])
    redirect_to reported_admins_path
  end

  # @Author: Nada Nasr
  # @Summary: hides the marked needs from the admin's view by calling the action 
  #           hide_needs(needs_to_hide) in the model 
  # @paramName: params[:need_ids] => ids of needs the admin wants hidden
  def hide_marked_needs
    Admin.find(current_admin.id).hide_needs(params[:need_ids])
    redirect_to reported_admins_path
  end


end
