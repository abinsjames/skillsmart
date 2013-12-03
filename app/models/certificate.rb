class Certificate
include MongoMapper::EmbeddedDocument

    key :certname, String  
    key :certdescription, String

    validates_presence_of :certname
    validates_presence_of :certdescription
    
    timestamps!
    
end
