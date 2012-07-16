#@Author = Nada Nasr
class Question
  include Mongoid::Document

  field :content, :type => String

  validates :content, :presence => true
end
