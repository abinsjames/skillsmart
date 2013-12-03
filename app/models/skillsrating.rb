class Skillsrating 
include MongoMapper::Document

    key  :userid, String  
    key  :jobID, String 
    many :skillrating
    
    timestamps!

	validates_presence_of :userid
	validates_presence_of :jobID
    
end
