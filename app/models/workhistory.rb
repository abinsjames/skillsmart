class Workhistory
include MongoMapper::EmbeddedDocument

    key :title, String  
    key :company, String
    key :fromdate, String
    key :tilldate, String
    
    timestamps!

	validates_presence_of :title
    validates_presence_of :company
    validates_presence_of :fromdate
    validates_presence_of :tilldate
    
end
