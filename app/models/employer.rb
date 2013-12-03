class Employer
  include MongoMapper::Document

    key :name, String   
	key :address, String    	
	key :city, String  			
	key :state, String  		
	key :zip, Integer  	
	key :companytype, String  			
			
	
    timestamps!

    validates_presence_of :address
    validates_presence_of :city
    validates_presence_of :state
    validates_numericality_of :zip
    validates_presence_of :companytype
    
end
