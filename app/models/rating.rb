class Rating 
include MongoMapper::EmbeddedDocument

    key  :jobseekerid, String 
    key  :rating, String 
    
    timestamps!

	validates_presence_of :jobseekerid
	validates_presence_of :rating
    
end
