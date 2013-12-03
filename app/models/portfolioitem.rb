class Portfolioitem
  include MongoMapper::Document

    key :portfolioid, String     
	key :portfolioitemtypeid, String 
	key :asset, String
	
    timestamps!

    validates_presence_of :portfolioid
    validates_presence_of :portfolioitemtypeid
    
    
end
