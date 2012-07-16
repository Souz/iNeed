class Authentication
  include Mongoid::Document
  
  #@Author: Mohamed Diaa
    #@summary: This class is the link between the user account and the iNeed account
    #@ParamName: "uid" : is the provider account, user id
    #@ParamName: "provider" : is the scocial Network that we are linking to, eg: facebook
  field :provider, :type => String
  field :uid, :type => String
  belongs_to :customer

  def handle_unverified_request
    true
  end

  def self.find_by_provider_and_uid (p,u)
      (self.where(:provider => p, :uid => u))[0]
  end

end
