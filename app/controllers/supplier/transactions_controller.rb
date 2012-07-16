#Author = Mirna ElBendary

class Supplier::TransactionsController < SupplierController

layout 'supp_master'


  #Author = Mirna ElBendary
  #summary = lists all transactions, used for testing only.
	def index
    begin
      @transactions = Transaction.all

       respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @transactions }
     	  end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
 	end
    
  #Author = Mirna ElBendary
  #summary = the method takes the code inserted by the supplier and checks if it is correct or not. 
  #@paramName:@transaction => selects from the database the first transaction where the id is equal to the one entered by user.
  def insert_code
    begin
      @transaction = Transaction.first(:conditions => {:id => params[:code]})
      if @transaction == nil
        flash[:notice] = 'Please enter a Valid code.'
      elsif @transaction.done == true
        flash[:notice] = 'Sorry, this transaction is already done.'
      else 
        @transaction.done = true
        @transaction.update_attributes(done: 'true')
        redirect_to  supplier_offers_url, notice: 'Transaction done. Your money will be sent shortly.'
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end
  
  #Author = Mirna ElBendary
  #summary = the method shows the id and the boolean of the transaction.
  def show
    begin
      @transaction = Transaction.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @transaction }
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end
  
  #Author = Mirna ElBendary
  #summary = the method renders the form for a new transaction.
  def new
    begin
      @transaction = Transaction.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @transaction }
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end
  #Author = Mirna ElBendary
  #summary = the method creates a new transaction.

  def create
    begin
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
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end
  
  #Author = Mirna ElBendary
  #summary = the method deletes a transaction.
  def destroy
    begin
      @transaction = Transaction.find(params[:id])
      @transaction.destroy

      respond_to do |format|
        format.html { redirect_to  supplier_offers_url }
        format.json { head :no_content }
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

end

