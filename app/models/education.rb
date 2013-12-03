class Education
include MongoMapper::EmbeddedDocument

    key :degree, String  
    key :college, String
    key :date, String
    key :field, String
    
    timestamps!

	validates_presence_of :degree
    validates_presence_of :college
    validates_presence_of :date
    
    
end
