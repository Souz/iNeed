class TransactionsController < ApplicationController
  # GET /transactions
  # GET /transactions.json

    layout :choose_layout
    private
def choose_layout  
if current_supplier == nil
  return 'cust_master'
else
  return 'supp_master'
end
end
  #lists all transactions, not actually used in the system. only used for testing
  def index
    @transactions = Transaction.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
    end
  end

  #Action: insert_code:
  #after the customer subscribes to a certain offer, he gets a code. insert_code is called somewhere else
  #where the supplier clicks on it whenever he gets a code and enters the code.
  #if  he does not enter anything or if he enters a wrong code then a message is displayed "please enter 
  # a valid code." If he enters a code that was entered before, a message is also displayed.
  # otherwise, the boolean is changed to true and the method redirects to myoffers.
   
   def insert_code
    @transaction = Transaction.first(:conditions => {:id => params[:code]})

    if @transaction == nil
      flash[:notice] = 'Please enter a Valid code.'
    elsif @transaction.done == true
      flash[:notice] = 'Sorry, this transaction is already done.'

    else 
      @transaction.done = true
      @transaction.update_attributes(done: 'true')
      redirect_to myoffers_url, notice: 'Transaction done. Your money will be sent shortly.'
    end
  end


   

  # GET /transactions/1
  # GET /transactions/1.json

  #the method shows the data of the transaction; the code and the status (done or not)
  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.json


  #New: renders a form which asks "are you sure you want to subscribe that offer?" if yes then a new 
  #transaction is created.
  def new
    @transaction = Transaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/1/edit
  #def edit
   # @transaction = Transaction.find(params[:id])
  #end

  # POST /transactions
  # POST /transactions.json


  #Creates a new transaction
  def create
    @transaction = Transaction.new(params[:transaction])

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: 'Transaction was successfully created.' }
        format.json { render json: @transaction, status: :created, location: @transaction }
      else
        format.html { render action: "new" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.json

  #Update transaction, not needed 
 # def update
 #   @transaction = Transaction.find(params[:id])

  #  respond_to do |format|
  #    if @transaction.update_attributes(params[:transaction])
  #      format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @transaction.errors, status: :unprocessable_entity }
  #    end
  #  end
 # end

  # DELETE /transactions/1
  # DELETE /transactions/1.json

  #Delete: deletes transaction 
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to myoffers_url }
      format.json { head :no_content }
    end
  end
end
