class Example
include MongoMapper::EmbeddedDocument

    key :examplename, String  
    key :exampledescription, String

    validates_presence_of :examplename
    validates_presence_of :exampledescription
    
    timestamps!
    
end
