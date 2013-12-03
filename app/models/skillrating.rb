class Skillrating 
include MongoMapper::EmbeddedDocument

    key  :skillid, String 
    key  :priority, Integer , :default => 1
    key  :ranking, Integer , :default => 1   
    
    timestamps!

	validates_presence_of :skillid
	validates_presence_of :priority
	validates_presence_of :ranking
    
end
