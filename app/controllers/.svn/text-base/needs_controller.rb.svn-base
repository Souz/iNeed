#@Author = Doha
class NeedsController < ApplicationController
  #@author: Amir Emad
  # GET /needs
  # GET /needs.json
    layout :choose_layout
    before_filter :authenticate_customer!, :except => [:show, :index, :search, :filter]
    #private
    def choose_layout  
      if current_supplier.nil?
        return 'cust_master'
      else
        return 'supp_master'
      end
    end


  # gets an array of needs in the database
  def index
    @needs = Need.all
    @needs = @needs.map {|n| Need.find(n.id)} # @needs in the list of needs
    @needs = @needs.keep_if{|n| !n.deleted}.paginate :page => params[:page],:per_page => 10
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @needs }
      format.js
    end
  end

  #@Author: Nisma El-Nayeb
  #@Summary: The show controller is responsible for retrieving the data I want to display in
  #          the need's page such as the need's details and offers made on this need.
  #@ParamName: @need => holds the object need that the user want to view.
  #@Author: Hazem El-Kilisly
  #@Summary: Doing configuration for drawing the charts.
  #@ParamName: @chart => the instant variable of chart itself.
  def show
    begin
      @need = Need.find(params[:id])
      @offers = @need.offers
      @cat_id = @need.category_id
      @needcat = Category.find(@cat_id) 
      @listrelatedneeds = @needcat.needs.excludes(deleted: true)
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
      @num_of_needers_in_locations = @need.num_of_needers_in_locations
      @need_id = params[:id]
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @need }
      end
    rescue
      redirect_to :root
    end
  end

  #@author: Amir Emad
  #@summary: Waits for a variable need_name_auto passed in paramas to query elasticsearch and get the results and returns them
  #in @needs and passes the query for filtering.
  def search
    if params[:need_name_auto].lstrip != ''
      params[:need_name_auto] = params[:need_name_auto].lstrip
    end

    if params[:need_name_auto] != '' and params[:need_name_auto][0]!=' '
      begin
        @needs = Need.tire.search params[:need_name_auto]
      rescue
        @needs = []
      end

      temp = []
      @needs.each do |need|
        begin
          temp = temp + [Need.find(need.id)]
        rescue
        end
      end

      @needs = temp
      @needs = @needs.keep_if{|n| !n.deleted}
    else
      @needs = []
    end
    @needs = @needs.paginate :page => params[:page],:per_page => 10
    @query = params[:need_name_auto]
  end

  #@author: Amir Emad
  #@summary: Waits for a variable need_name passed in paramas to query elasticsearch and get the results and then filter them 
  #and return them in the list @needs and sends the query again to use it in further filtering.
  def filter
    if params[:need_name] != '' and params[:need_name][0]!=' '
      begin
        @needs = Need.tire.search params[:need_name]
      rescue
        @needs = []
      end
      @query = params[:need_name]
      temp = []
      @needs.each do |need|
        begin
          temp = temp + [Need.find(need.id)]
        rescue
        end
      end
      @needs = temp
    else
      if params[:need_name] == ''
        @needs = Need.all
      elsif params[:need_name][0]==' '
        @needs = []
      end
      @needs = @needs.map {|n| Need.find(n.id)}
      @query = params[:need_name]
    end

    if params[:category_name] != ''
      @needs = @needs.keep_if {|n| n.category_name == params[:category_name]}
    end

    begin
      if params[:low_bound] != ''
        @needs = @needs.keep_if {|n| n.price_greater?(Integer(params[:low_bound]))}
      end
    rescue
      redirect_to :back, :notice => 'Please enter numbers in the price range fields'
      return
    end

    begin
      if params[:high_bound] != ''
        @needs = @needs.keep_if {|n| n.price_less?(Integer(params[:high_bound]))}
      end
    rescue
      redirect_to :back, :notice => 'Please enter numbers in the price range fields'
      return
    end

    @needs = @needs.keep_if{|n| !n.deleted}.paginate :page => params[:page],:per_page => 10
    params[:need_name_auto] = params[:need_name]
  end

   #displays new need form
  def new
    @need = Need.new
    if Category.where('name'=>'Others').empty?
      category_others = Category.create('name'=>'Others')
      category_others.save
    end
    @categories=Category.get_leaf_categories
    render(:template => '/needs/new')
  end

  # GET /needs/1/edit
  def edit
    @need = Need.find(params[:id])
  end

  #creates a new need
  def create
    @need = Need.new(params[:need]) 
    @need.customer= current_customer.id 
    @need.deleted = false
    need_category = (Category.where('name'=>@need.category_name))[0]
    if !need_category.nil?
      @need.category = need_category.id
    end
    @categories=Category.get_leaf_categories
    respond_to do |format|
      if @need.save
        format.html { redirect_to :controller =>'customer/needs',:action => 'show', :id => @need.id}
      else
        format.html { render action: "new" }
        format.json { render json: @need.errors, status: :unprocessable_entity }
      end
    end
  end


#@Author: "Doha"
#@Summary: The action recieves the choice submitted from the form in the search view then goes into its belonging if condition to sort the search results according to the certain criteria chosen.
#@paramName: "@need" => gets the needs names and set into this array to be sorted
#@paramName: "@querey" => gets the needs name according to what is passed in the from tag heiden field.  
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
          @needs_list = []
          @needs_nil = []
          @needs.each do |need|
            if (!need.offers.empty?)
            @offers << Offer.sorting_offers_desc(need.id)
          else
            @needs_nil << need
          end
          end
          @offers = @offers.flatten
          @offers = @offers.sort_by{|s| s.price}.reverse
          @offers.each do |offer|
            @needs_list << offer.need 
          end
          @needs_list << @needs_nil
          @needs = @needs_list.flatten
          @needs = @needs.map {|n| Need.find(n.id)}.paginate :page => params[:page],:per_page => 10
          elsif choice == 'Price_low_to_high'
            @offers = []
            @needs_list = []
            @needs_nil = []
            @needs.each do |need|
              if (!need.offers.empty?)
                @offers << Offer.sorting_offers_asc(need.id)
              else
                @needs_nil << need
              end
            end
            @offers = @offers.flatten
            @offers = @offers.sort_by{|s| s.price}
            @needs_list << @needs_nil
            @offers.each do |offer|
              @needs_list << offer.need 
            end
            @needs = @needs_list.flatten
            @needs = @needs.map {|n| Need.find(n.id)}.paginate :page => params[:page],:per_page => 10
            elsif choice == 'Most Needed'
              @needs = @needs.sort_by { |s| s.total_needers }.to_a
              @needs = @needs.reverse
              @needs = @needs.map {|n| Need.find(n.id)}.paginate :page => params[:page],:per_page => 10
    end 
      @needs.keep_if{|n| !n.deleted}
      render :action => "search"
  end

end
