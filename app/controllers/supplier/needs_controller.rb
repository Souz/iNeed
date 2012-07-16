class Supplier::NeedsController < SupplierController
  #@Author: "Mirna Elbendary"

	# GET /needs
  # GET /needs.json
    layout :choose_layout
    #private
    def choose_layout  
      if current_supplier == nil
        return 'cust_master'
      else
        return 'supp_master'
      end
    end
    
  #this is the action for the tracked page that shows all the categories and the needs tracked by this supplier
  def index
    begin
      @needs = current_supplier.needs.paginate :page=>params[:page], :per_page=>10
      categories = []
      current_supplier.categories.each do |category|
        if category.leaf?
          categories.push(category)
        end
      end 
      @categories = categories.paginate :page => params[:categories], :per_page => 5
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end
  
  
  #@Author: "Mirna Elbendary"
  #@summary= hot_needs_supplier searches in the database to find all needs that have the maxneeders
  #those needs are then put in an a table and displayed in the "hot_needs_supplier.haml" file.
  #@paramname= "@needs" => this is a list of all needs with maximum needers
  def hot_needs_supplier
    begin
      @need =  Need.first(:conditions => {:total_needers => Need.max(:total_needers)})
      if @need.total_needers == 0
        @needs = []
      else
        @needs = Need.all_of(:total_needers.gte => (0.7 * @need.total_needers)).excludes(deleted: true).limit(20)
      end
      @needs = @needs.paginate :page => params[:page],:per_page => 10
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # track_need is a method used to track need for the supplier, it also adds the data that he/she specifies to get notified for
  # the data includes the location ans the Quantity. he wants to get notified when the quantity reaches :quanntity in location :location
  # data is saved in "notify_array" array, which is an array of arrays in this form : [[need_id, location, quantity], .....]
  # this is all saved in the supplier's class
  def track
    begin
      if Need.find params[:need_id]
        @need = Need.find(params[:need_id])
        unless current_supplier.needs.include? @need
          current_supplier.needs.push(@need)
          current_supplier.save
          #render(:text => 'Tracked')
          #redirect_to :back
        end
      else
        #redirect_to :back
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
    respond_to do |format|
        format.html{ redirect_to :back} 
        format.js
      end
  end

  def untrack
    begin
      if Need.find params[:need_id]
        @need = Need.find(params[:need_id])
        if current_supplier.needs.find(@need.id)
          current_supplier.needs.delete(@need)
          #redirect_to :back
        else
          #redirect_to :back  
        end
      else
        #redirect_to :back
      end
      respond_to do |format|
        format.html{ redirect_to :back} 
        format.js
      end    
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end
  
  
  #@Author: Mirna elBendary
  #@Summary: The notify_view links to the view. it sends the need is and supplier id to it
  #@ParamName: "number_needers" where the number of needers entered by the user is stored.
  #@ParamName: "location" where the location entered by the user is stored.
  def notify_view
    begin
      if (Need.find params[:need_id])
        @need = Need.find(params[:need_id])
        @supplier = Supplier.find(params[:supplier_id])
      else 
        redirect_to hot_needs_supplier_supplier_needs_path
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  #@Author: Mirna elBendary
  #@Summary: The notify_action takes the input from the view and stores it in an array,
  #@ParamName: "number_needers" where the number of needers entered by the user is stored.
  #@ParamName: "location" where the location entered by the user is stored.
  #@ParamName: "location_quantity" where the need_id,location and number of needers entered by the user are stored.
  def notify_action
    begin
      if (Need.find params[:need_id])
        @need = Need.find(params[:need_id])
        @supplier = Supplier.find(params[:supplier_id])
        number_needers = params[:number_users]
        location = params[:location]
        @location_quantity = Array.new
        @location_quantity[0,2] = [@need.id, location, number_needers]
        @supplier.notify_array.push(@location_quantity)
      else 
        redirect_to hot_needs_supplier_supplier_needs_path
      end
       redirect_to hot_needs_supplier_supplier_needs_path
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
 end
 
    #@Author = Mirna ElBendary
    #@summary = checks if the need_id is equal to that stored in the array. if so, then the array is deleted.
    #@paramName: location_quantity = the array of need_id, location and number of needers.
   def unnotify
    begin
      @supplier = Supplier.find(params[:supplier_id])
      @need = Need.find(params[:need_id])
      @supplier.notify_array.each do |location_quantity|
        if (@need.id == location_quantity[0])
          location_quantity.delete 
          redirect_to :back,  notice: 'unnotified'
        else
          redirect_to hot_needs_supplier_supplier_needs_path, notice: 'it is not notified'
        end
      end
      redirect_to hot_needs_supplier_supplier_needs_path
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end
  
 

    #@Author: Nisma El-Nayeb
    #@Summary: The show controller is responsible for retrieving the data I want to display in
    #          the need's page such as the need's details and offers made on this need.
    #@ParamName: "@banned_supplier" => holds value true if the current_supplier is banned and
    #            else false.
    #@ParamName: "@offers" =>  holds the list of offers made on the need the current_supplier is
    #            viewing.
    def show
      begin
        @need = Need.get_need(params[:id])#get need with this id
        if current_supplier != nil
          @banned_supplier = Supplier.is_banned(current_supplier.id)
        end
        @offers = @need.offers
        
        @cat_id = @need.category_id#get category id of this need
        @needcat = Category.find(@cat_id) #returns category of this need with this id
        @listrelatedneeds = @needcat.needs # returns all needs(id) under this category in list
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
    rescue
      flash[:notice] = "Nice try, but next time you have to be smarter! ;D"
      redirect_to supplier_offers_path
    end
  end

end
