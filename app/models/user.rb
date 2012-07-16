# @Author = Nada Nasr
class User
  include Mongoid::Document
  include Mongoid::Paperclip

  attr_accessible :password,:email,:location,:name
  field :name, :type => String
  field :phone, :type => String
  field :address, :type => String
  field :location, :type =>String
  
  field :name, :type => String
  field :email, :type => String
  field :password, :type => String
  field :phone, :type => String
  field :address, :type => String
  field :location, :type =>String

  
  has_many :needs


  # photo 
  has_mongoid_attached_file :photo,  
  :styles =>{ :normal => "70x70>", :small => "70x70" },
  :url => "/assets/Users/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/Users/:id/:style/:basename.:extension",
  :default_url => 'user.png'



  #validations
validates_presence_of :location, :message => "should be entered!"
validates_presence_of :name, :message =>"should be entered!"

 #A method that takes a user's ID and returns the type of that user.   
 def self.get_type(user_id)
  @type = User.select(:type).where(:user_id => user_id)
  return @type
 end 
 
  # @Author: Nada Nasr
  # @Summary: generates string of the following form 'mailto:?to=email_1@domain.com%2C%20email_2@domain.com...'
  # @paramName: user_ids => list of users to generate the mailto string for
  def self.mailto_string(user_ids)
    @users = User.find(user_ids)
    @emails = @users.map {|u| u.email}
    mailto_string =  "mailto:?to=" << @emails[0]
    for i in 1..(@emails.size - 1)
      mailto_string << "%2C%20"<< @emails[i]
    end
    return mailto_string
  end

end
