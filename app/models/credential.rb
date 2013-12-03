class Credential
  include MongoMapper::Document

    key   :description, String
	many  :accreditingagency
	
    timestamps!

    validates_presence_of :description
    
end
