class Resume
include MongoMapper::EmbeddedDocument

    key :name, String  
    key :orders, Integer, :default => 0
    
    timestamps!

	validates_presence_of :name
    validates_format_of :name, :with => /.pdf$/
    
    
end
