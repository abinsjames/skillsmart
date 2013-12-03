class Accreditingagency
include MongoMapper::EmbeddedDocument

    key :name, String  
    key :website, String
    
    timestamps!

	validates_presence_of :name
    validates_presence_of :website
    
end
