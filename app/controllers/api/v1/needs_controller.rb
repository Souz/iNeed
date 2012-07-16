#@author: Marina Charles
class Api::V1::NeedsController < Api::V1::BaseController
  respond_to :json
  before_filter :restrict_access, :only => [:iNeed, :un_need, :like, :dislike, :unlike]

  def index
    respond_with Need.all
  end

  def show
    respond_with Need.find(params[:id])
  end
#@author: Marina Charles
#@summary: in this action i put in xml file the information needed to display the similar needs using respond_with
#@need: "id" => gets the need with following id
#@cat_id: gets the category id of that need
#@needcat:"@cat_id" => gets the category of that need
#@listrelatedneeds: places all the similar needs in that list

  def getlistrelatedneeds

    @need = Need.find(params[:id])
    @cat_id = @need.category_id
    @needcat = Category.find(@cat_id) 
    @listrelatedneeds = @needcat.needs
    respond_with @listrelatedneeds

  end
#@author: Marina Charles
#@summary: in report need i put in xml file all the information needed to report a need
#@need: "id" => get the need of the following id
#@report: "report" => i get the content of the report
#@need.report: "report" => i save content in report(string)
#@need.records: "current_customer.id.to_s","@report" => i store the id of customer(key) and the content of report(value) in hash records when clicking on submit(in need's show(view))
#@need.reported: "id" => i set the value to true when the need with this "id" is reported
  def report_need 
    @need = Need.find(params[:id])
    @report = params[:report]
    @need.report = params[:report]
    @need.save
    @need.records.store(current_customer.id.to_s,@report)
    @need.save
    @need.reported = true
    @need.save
   respond_with @need
  end

  def search
    if params[:need_name_auto] != ''
      @needs = Need.tire.search params[:need_name_auto]
      @needs = @needs.map {|n| Need.find(n.id)}
    else
      @needs = []
    end
    respond_with @needs
  end

#@Author: Mohamed Diaa
#@summary: action for needing a certain need
#@ParamName: "params[:id]"" : repewsents the id of the specified need
#@ParamName: "@need": is the need object which was specified in the request
#@ParamName: "@need.total_needers":  is the total number of needer on this specific need "@need"
  def iNeed
    @need = Need.find(params[:id])
    @need.total_needers = @need.total_needers+1
    if @need.save
      @need.customers.concat(current_customer)  
      current_customer.needs.concat(@need)
      #respond_with the @need returns the need after the changes, with http status :OK (201) successful
      respond_with @need, :status => :ok
    else
      #responds_with status Client Error 422 Unprocessable Entity
      respond_with :status => :unprocessable_entity
    end
  end

    #Author :: Sarah El-Sherbiny
    #this is the action for un-need button for the api 
    def un_need
    @need = Need.find(params[:need_id])
    customer_needs = current_customer.needs.length
    @need.total_needers = @need.total_needers-1
    if @need.save
      current_customer.needs.delete(@need)
      @need.customers.delete(current_customer)
    end
    Transaction.remove_transactions_on_need(@need,current_customer)
    respond_with @need
  end

  def sorting
    choice = params["sorting_choice"]
    @needs = Need.tire.search params[:need_name]
    @query = params[:need_name]
    @needs = @needs.map {|n| Need.find(n.id)}
    if choice == 'Ascending'
    @needs = @needs.sort_by { |s| s.name }.to_a
    @needs = @needs.map {|n| Need.find(n.id)}.paginate :page => params[:page],:per_page => 10
    elsif choice == 'Descending'
      @needs = @needs.sort_by { |s| s.name }.to_a
      @needs = @needs.reverse
      @needs = @needs.map {|n| Need.find(n.id)}.paginate :page => params[:page],:per_page => 10
        elsif choice == 'Price_high_to_low'
          @offers = []
          @needs.each do |need|
            @offers << Offer.sorting_offers_desc(need.id)
          end
          @needs = @offers.flatten
          @needs = @needs.map {|n| Need.find(n.id)}.paginate :page => params[:page],:per_page => 10
          elsif 'choice' == 'Price_low_to_high'
            @offers = []
            @needs.each do |need|
              @offers << Offer.sorting_offers_asc(need.id)
            end
            @needs = @offers.flatten
            @needs = @needs.map {|n| Need.find(n.id)}.paginate :page => params[:page],:per_page => 10
            elsif 'choice' == 'Most Recent offers'
              @offers = []
              @needs.each do |need|
                @offers << Offer.sorting_offers_date(need.id)
              end
              @needs = @offers.flatten
              @needs = @needs.map {|n| Need.find(n.id)}.paginate :page => params[:page],:per_page => 10
    end 
    respond_with @needs
  end
  
  #@Author: Nisma El-Nayeb
  #@Summary: api action for liking a comment
  #@ParamName: "comment" => the comment that the current_customer wants to like
  #@ParamName: "current_customer" => the current_customer who likes a comment
  #@ParamName: ":up" => indication that the user is voting up as opposed to voting 
  #            down(dislike)
  def like
    comment = Comment.get_comment(params[:comment])
    current_customer.vote(comment, :up)
    respond_with comment
  end

  #@Author: Nisma El-Nayeb
  #@Summary: api action for disliking a comment
  #@ParamName: "comment" => the comment that the current_customer wants to dislike
  #@ParamName: "current_customer" => the current_customer who dislikes a comment
  #@ParamName: ":down" => indication that the user is voting down as opposed to voting 
  #            up(like)
  def dislike
    comment = Comment.get_comment(params[:comment])
    current_customer.vote(comment, :down)
    respond_with comment
  end

  #@Author: Nisma El-Nayeb
  #@Summary: api action for undoing liking or disliking a comment
  #@ParamName: "comment" => the comment that the current_customer wants to remove his/her
  #            vote from.
  #@ParamName: "current_customer" => the current_customer who wants to remove his/her
  #            vote.
  def unlike
    comment = Comment.get_comment(params[:comment])
    current_customer.unvote(comment)
    respond_with comment
  end
  
end
