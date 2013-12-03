class Portfolioitemskill
  include MongoMapper::Document

    key :portfolioitemid, String
	key :skillid, String
	many  :value
	
    timestamps!

    validates_presence_of :portfolioitemid
    validates_presence_of :skillid
    
    
end
