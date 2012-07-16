# @Author = Nada Nasr
class Feedback
  include Mongoid::Document
  field :rating, type: Float
  field :comment, type: String
  field :reported, type: Boolean,default: false
  
  belongs_to :transaction
  
  #@Author : Sarah El-Sherbiny
  #@summary: class method to get the feedback of a transaction
  def self.get_feedback(transaction_id)
  	(self.where(:transaction_id => transaction_id))[0]
  end
end
