# @Author: Nada Nasr
class Customer::FeedbackController < ApplicationController

  layout 'cust_master'

	# @Author: Nada Nasr
	# @Summary: creates a new instance of feedback given that the logged in customer
  #           is allowed to give feedback on the given transaction. A customer is 
  #           only allowed to give feedback once, and on offers that have expired.
  # @paramName: params[:transaction_id] => the transaction id of the transaction which the customer
  #                                       wants to give feedback about
	def new

    @transaction = Transaction.find(params[:transaction_id])
    offer = Offer.find(@transaction.offer.id)
    @supplier = Supplier.find(offer.supplier.id)

    if !Feedback.where(transaction_id: @transaction.id).empty? || !@transaction.done
      flash[:notice] = "You have already given feedback on this offer. Thank you for your co-operation."
      redirect_to my_needs_customer_needs_path
    end

		@questions = Question.all
		@feedback = Feedback.new
	end

	# @Author: Nada Nasr
	# @Summary: creates a feedback object with the rating calculated from the form and the comment given in it.
	#           calculates rating from submitted form as average of the weights of all answers and updates the 
  #           corresponding supplier rating accordingly.
  # @paramName: params[:feedback] => the feedback's form parameters
  # @paramName: params[:anwers] => the list of selected radiobuttons
	def create
    @feedback = Feedback.new(params[:feedback])

    answers = params[:answers]
    if !answers.nil?
      rating = answers.keys.map{|i| answers[i].to_i}.inject(:+) / answers.size
      @feedback.rating = rating
    end
    
    @feedback.transaction = Transaction.find(params[:feedback][:transaction_id])

		if @feedback.save
      if !answers.nil?
        @feedback.transaction.offer.supplier.update_rating(rating)
      end
      flash[:notice] = "Your feedback has successfully been submitted. Thank you for your co-operation." 
      redirect_to my_needs_customer_needs_path
    else
      flash[:notice] = "Your form was not successfully submitted. Please try again." 
      redirect_to my_needs_customer_needs_path
    end
	end
end