class Courseskilllearned
  include MongoMapper::Document

    key :courseid, String  
	key :skillid, String 
	
	
    timestamps!

    validates_presence_of :courseid
    validates_presence_of :skillid
    
end
