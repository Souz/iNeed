class Key
  include Mongoid::Document
  field :access_token, :type => String
  belongs_to :customer
	before_create :generate_access_token
	
  def self.find_by_access_token(access_token)
    (self.where(:access_token => access_token))[0]
  end

  private
		def generate_access_token
		  begin
		    self.access_token = SecureRandom.hex
		  end while self.class.exists?(access_token: access_token)
		end
end