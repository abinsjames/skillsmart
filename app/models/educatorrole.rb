class Educatorrole
  include MongoMapper::Document

    key :educatorRole, String  
	 
	
	
    timestamps!

    validates_presence_of :educatorRole
    
end
