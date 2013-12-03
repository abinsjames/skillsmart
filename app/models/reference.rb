class Reference
include MongoMapper::EmbeddedDocument

    key :refname, String  
    key :refdescription, String

    validates_presence_of :refname
    validates_presence_of :refdescription
    
    timestamps!
    
end
