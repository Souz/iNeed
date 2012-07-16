class Supplier::FeedbacksController < SupplierController

  layout :choose_layout

  #@author: Sarah El-Sherbiny
  #@summmary: action to choose layout because feedbacks can be viewed by an admin or a supplier
  def choose_layout
    if current_supplier.nil?
      'admin'
    else
      'supp_master'
    end
  end
  #@Author: Sarah El-Sherbiny
  #@summary:action to show feedback comments for a supplier
  #@paramName: "feedback" => the reported feedback	
	def report
		feedback = Feedback.find(params[:feedback_id])
		feedback.reported = true
		feedback.save
		redirect_to :back
	end

  #@Author: Sarah El-Sherbiny 
  #@summary:action to show feedback comments for a supplier
  #@paraName: "@feedbacks" => list of feedbacks to be shown in the view for the supplier	
	def view
		@feedbacks = []
		offers = Offer.get_offers_for_supplier(params[:supplier_id])
    	offers.each do |offer|
        transactions = [] 
      	transactions = Transaction.get_transactions_for_offer(offer.id)
        transactions.each do |transaction|
          if Feedback.get_feedback(transaction.id)
            @feedbacks << Feedback.get_feedback(transaction.id)
          end
        end
    	end
      @feedbacks
  	end

  def show
  end  


end