class Value
include MongoMapper::EmbeddedDocument

    key :proficency, Integer  
    key :experience, Integer

	many  :certificate
	many  :reference
	many  :example
    
    timestamps!
end
