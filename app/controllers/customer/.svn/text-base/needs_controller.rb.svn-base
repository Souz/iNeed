#@author: Marina Charles
#@author: Nourhan Azab
#@Author: Yousra Hazem
#@Author: Sarah El-Sherbiny
class Customer::NeedsController < CustomerController
  
 layout 'cust_master'
  # GET /needs/1
  # GET /needs/1.json
  
  #Author :: Sarah El-Sherbiny
  #@summary :the action for the customer to need any existing need
  #@paramName: "@need" => this is the need that a customer wants to need 
  #########
  #@Author: Yousra Hazem
  #@summary: Locate needer is called from this action
  #@paramName: "current_customer.location" => the location of the customer
  def iNeed
    @need = Need.find(params[:id])
    @need.total_needers = @need.total_needers+1
    @need.locate_needer(current_customer.location)
    @offers = @need.offers
      @offerlist = @need.offers.desc(:num_of_subscribed_quantity) #List of Offers of that Need
      numberofoffers = @offerlist.size #no of offers for this need.
      @offerlist = @offerlist.map{|offer| Offer.find(offer.id)}
      @offerlist = @offerlist.keep_if{|offer| !offer.deleted}
      if ( !@offerlist.empty? )&&( ((@offerlist[0]).num_of_subscribed_quantity * 1.0) != 0 )

        sum = 0 #init all quantity subscribed to all offers = 0
        list = []  #init empty list to be passed to the chart

        if numberofoffers > 4

          #loop to get first 5 subscipers on all offers on that need.
          for i in 0..4
            sum += ((@offerlist[i]).num_of_subscribed_quantity * 1.0)
          end

          #make a list if lists to be passed to the chart
          for i in 0..4
            supp = Supplier.find(@offerlist[i].supplier_id)
            list << [supp.email, ( @offerlist[i].num_of_subscribed_quantity * 1.0 ) ]
          end
        else
          #loop to get all number of subscipers on all offers on that need.
          @offerlist.each do |offer|
            sum += ((offer).num_of_subscribed_quantity * 1.0)
          end

          #make a list if lists to be passed to the chart
          @offerlist.each do |offer|
            supp = Supplier.find(offer.supplier_id)
            list << [supp.email, ( offer.num_of_subscribed_quantity * 1.0 ) ]
          end

        end
         @chart = LazyHighCharts::HighChart.new('pie') do |f|
            f.chart({:defaultSeriesType=>"pie"} )
            series = {
                     :type=> 'pie',
                     :name=> 'Offers Share',
                     :allowPointSelect=> true,
                     :data=> list
            }
            f.series(series)
            f.options[:title][:text] = "Share Of subscribers"
            f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> 'auto',:top=> 'auto'}) 
            f.plot_options(:pie=>{
              :allowPointSelect=>true, 
              :cursor=>"pointer" , 
              :dataLabels=>{
                :enabled=>true,
                :color=>"white",
                :style=>{
                  :font=>"13px Trebuchet MS, Verdana, sans-serif"
                }
              }
            })
      end
      end
    if @need.save
      @need.customers.concat(current_customer)  
      current_customer.needs.concat(@need)
      flag = params[:go_to_my_needsflag]
    end
    respond_to do |format|
      format.html{ redirect_to :back} 
      format.js
    end
  end

  #@author: Marina Charles
  #@summary: in the show i display related needs to a similar need, getting the need's category and putting in the listrelatedneeds all the need's that falls under this category and in need's show(view) i put the similar needs in a table showing only the picture and name and excluding the original need
  #@need: "id" => get the need of the following id
  #@cat_id: "id" => get the category's id's need
  #@needcat: "@cat_id" => get all the needs that have the same category as the original need
  #@need.listrelatedneeds: "@needcat.needs" => puts all the related needs in this list
  ###############
  #@Author: Nisma El-Nayeb
  #@Summary: The show controller is responsible for retrieving the data I want to display in
  #          the need's page such as the need's details and offers made on this need.
  #@ParamName: "@banned_cutomer" => holds value true if the current_customer is banned and
  #            else false.
  #@ParamName: "@needer" => holds value true if the current_customer is needing the need he/she
  #            is viewing.
  #@ParamName: "@offers" =>  holds the list of offers made on the need the current_customer is
  #            viewing.
  def show
    #begin
      @need = Need.find(params[:id])#get need with this id
      if current_customer != nil
        @banned_customer = Customer.is_banned(current_customer.id)
      end
      @offers = @need.offers

      @cat_id = @need.category_id#get category id of this need
      @needcat = Category.find(@cat_id) #returns category of this need with this id
      @listrelatedneeds = @needcat.needs.excludes(deleted: true)# returns all needs(id) under this category in list
      #Code by "Hazem El-Kilisly" => Start
      @offerlist = @need.offers.desc(:num_of_subscribed_quantity) #List of Offers of that Need
      @offerlist = @offerlist.map{|offer| Offer.find(offer.id)}
      @offerlist = @offerlist.keep_if{|offer| !offer.deleted}
      numberofoffers = @offerlist.size #no of offers for this need.

      if ( !@offerlist.empty? )&&( ((@offerlist[0]).num_of_subscribed_quantity * 1.0) != 0 )

        sum = 0 #init all quantity subscribed to all offers = 0
        list = []  #init empty list to be passed to the chart

        if numberofoffers > 4

          #loop to get first 5 subscipers on all offers on that need.
          for i in 0..4
            sum += ((@offerlist[i]).num_of_subscribed_quantity * 1.0)
          end

          #make a list if lists to be passed to the chart
          for i in 0..4
            supp = Supplier.find(@offerlist[i].supplier_id)
            list << [supp.email, ( @offerlist[i].num_of_subscribed_quantity * 1.0 ) ]
          end
        else
          #loop to get all number of subscipers on all offers on that need.
          @offerlist.each do |offer|
            sum += ((offer).num_of_subscribed_quantity * 1.0)
          end

          #make a list if lists to be passed to the chart
          @offerlist.each do |offer|
            supp = Supplier.find(offer.supplier_id)
            list << [supp.email, ( offer.num_of_subscribed_quantity * 1.0 ) ]
          end

        end
         @chart = LazyHighCharts::HighChart.new('pie') do |f|
            f.chart({:defaultSeriesType=>"pie"} )
            series = {
                     :type=> 'pie',
                     :name=> 'Offers Share',
                     :allowPointSelect=> true,
                     :data=> list
            }
            f.series(series)
            f.options[:title][:text] = "Share Of subscribers"
            f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> 'auto',:top=> 'auto'}) 
            f.plot_options(:pie=>{
              :allowPointSelect=>true, 
              :cursor=>"pointer" , 
              :dataLabels=>{
                :enabled=>true,
                :color=>"white",
                :style=>{
                  :font=>"13px Trebuchet MS, Verdana, sans-serif"
                }
              }
            })
      end
      end
      # => End
      @need_id = params[:id]
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @need }
      end
    # rescue
    #   flash[:notice] = "Nice try, but next time you have to be smarter! ;D"
    #   redirect_to my_needs_customer_needs_path
    # end
  end
#@author: Marina Charles
#@summary: in report need i store the id of customer who has reported and the content of report, in the need's show(view), i use plugin modal bootstrap to display the popup containing the radio buttons
#@need: "id" => get the need of the following id
#@report: "report" => i get the content of the report
#@need.report: "report" => i save content in report(string)
#@need.records: "current_customer.id.to_s","@report" => i store the id of customer(key) and the content of report(value) in hash records when clicking on submit(in need's show(view))
#@need.reported: "id" => i set the value to true when the need with this "id" is reported
#Then i redirect the customer to his need's page
  def report_need 
    @need = Need.find(params[:id])
    @report = params[:report]
    @need.report = params[:report]
    @need.save
    @need.records.store(current_customer.id.to_s,@report)
    @need.save
    @need.reported = true
    @need.save
    Need.check_num_reports_on_need(@need.id)
    redirect_to :action => 'show', :id => @need.id
  end

#@author: Nourhan Azab
#@author :: Sarah El-Sherbiny
#@summary: displays a list of paginated my needs.Show my_needs with it's subscribed_offers
#for a customer , hot offers & hot needs
#@paramName:"@my_needs" => the list of needs belonging to this customer
#@paramName:"current_customer" => the current logged in customer instance.  
#@paramName:"@my_subscribed_offers" => the list of subscribed offers for all my_needs  
#@paramName:"@hot_offers_forCustomers" => the list of hot offers with respect to customers
#@paramName:"@hot_needs_forCustomers" => the list of hot needs with respect to customers
  def my_needs
      begin
        @my_needs = current_customer.needs.paginate :page=>params[:page],:per_page=>8,:remote => true
        @my_needs.delete_if{|need| need.deleted?}
        @my_subscribed_offers = []
        count = 0
        @my_needs.each do |need|
          @my_subscribed_offers[count] = Offer.list_subscribed_offers(need.id,current_customer.id)
          count +=1
        end
        @hot_offers_forCustomers = Offer.order_offers_by_percentage
        @hot_offers_forCustomers = @hot_offers_forCustomers.map{|o|Offer.find(o.id)}
        @hot_offers_forCustomers = @hot_offers_forCustomers.keep_if{|o|!o.deleted}.paginate :page=> params[:offerPage],:per_page=>5
        hot_needs =  Need.all.to_a.sort{|x,y| y.offers.keep_if{|n| !n.deleted}.count <=> x.offers.keep_if{|n| !n.deleted}.count}.keep_if{|n| !n.deleted}
        @hot_needs_forCustomers = hot_needs.keep_if{|n| !n.deleted}.paginate :page=> params[:needPage],:per_page=>5
        render(:template => 'customer/needs/my_needs')
      rescue
        flash[:notice] = "Nice try, but next time you have to be smarter! ;D"
        redirect_to needs_path
      end
  end 

#@author: Nourhan Azab
#@summary: un-needs a certain need by decrementing the number of total needers on 
#the corresponding need and removing the need from the list of this customer's
#needs. The customer is also removed from this need's array of customers.
#All transactions on this need belonging to this customer is removed thus unsubscribing
# the customer from them automatically. The action redirects to my needs page.
#@paramName:"need_id" => the id of the need to be un-needed
#@paramName:"@need" => the need instance to be un-needed
#@paramName:"current_customer" => the current logged in customer instance. 
  ############
  #@Author: Yousra Hazem
  #@summary: delocate needer is called from this action
  #@paramName: "current_customer.location" => the location of the customer
  def un_need
    @need = Need.find(params[:need_id])
    customer_needs = current_customer.needs.length
    @need.total_needers = @need.total_needers-1
    @need.delocate_needer(current_customer.location)
    @offers = @need.offers
      @offerlist = @need.offers.desc(:num_of_subscribed_quantity) #List of Offers of that Need
      @offerlist = @offerlist.map{|offer| Offer.find(offer.id)}
      @offerlist = @offerlist.keep_if{|offer| !offer.deleted}
      numberofoffers = @offerlist.size #no of offers for this need.

      if ( !@offerlist.empty? )&&( ((@offerlist[0]).num_of_subscribed_quantity * 1.0) != 0 )

        sum = 0 #init all quantity subscribed to all offers = 0
        list = []  #init empty list to be passed to the chart

        if numberofoffers > 4

          #loop to get first 5 subscipers on all offers on that need.
          for i in 0..4
            sum += ((@offerlist[i]).num_of_subscribed_quantity * 1.0)
          end

          #make a list if lists to be passed to the chart
          for i in 0..4
            supp = Supplier.find(@offerlist[i].supplier_id)
            list << [supp.email, ( @offerlist[i].num_of_subscribed_quantity * 1.0 ) ]
          end
        else
          #loop to get all number of subscipers on all offers on that need.
          @offerlist.each do |offer|
            sum += ((offer).num_of_subscribed_quantity * 1.0)
          end

          #make a list if lists to be passed to the chart
          @offerlist.each do |offer|
            supp = Supplier.find(offer.supplier_id)
            list << [supp.email, ( offer.num_of_subscribed_quantity * 1.0 ) ]
          end

        end
         @chart = LazyHighCharts::HighChart.new('pie') do |f|
            f.chart({:defaultSeriesType=>"pie"} )
            series = {
                     :type=> 'pie',
                     :name=> 'Offers Share',
                     :allowPointSelect=> true,
                     :data=> list
            }
            f.series(series)
            f.options[:title][:text] = "Share Of subscribers"
            f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> 'auto',:top=> 'auto'}) 
            f.plot_options(:pie=>{
              :allowPointSelect=>true, 
              :cursor=>"pointer" , 
              :dataLabels=>{
                :enabled=>true,
                :color=>"white",
                :style=>{
                  :font=>"13px Trebuchet MS, Verdana, sans-serif"
                }
              }
            })
      end
      end
    if @need.save
    current_customer.needs.delete(@need)
    @need.customers.delete(current_customer)
    end
    #Transaction.remove_transactions_on_need(@need,current_customer)
    respond_to do |format|
      format.html{ redirect_to :back} 
      format.js
    end
  end

  #@Author: Nisma El-Nayeb
  #@Summary: action for liking a comment
  #@ParamName: "comment" => the comment that the current_customer wants to like
  #@ParamName: "current_customer" => the current_customer who likes a comment
  #@ParamName: ":up" => indication that the user is voting up as opposed to voting 
  #            down(dislike)
  def like
    comment = Comment.get_comment(params[:comment])
    current_customer.vote(comment, :up)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  #@Author: Nisma El-Nayeb
  #@Summary: action for disliking a comment
  #@ParamName: "comment" => the comment that the current_customer wants to dislike
  #@ParamName: "current_customer" => the current_customer who dislikes a comment
  #@ParamName: ":down" => indication that the user is voting down as opposed to voting 
  #            up(like)
  def dislike
    comment = Comment.get_comment(params[:comment])
    current_customer.vote(comment, :down)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  #@Author: Nisma El-Nayeb
  #@Summary: action for undoing liking or disliking a comment
  #@ParamName: "comment" => the comment that the current_customer wants to remove his/her
  #            vote from.
  #@ParamName: "current_customer" => the current_customer who wants to remove his/her
  #            vote.
  def unlike
    comment = Comment.get_comment(params[:comment])
    current_customer.unvote(comment)
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end
