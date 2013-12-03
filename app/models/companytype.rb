class Companytype
  include MongoMapper::Document

    key :name, String
    key :description, String


    timestamps!

	validates_presence_of :name
    
end
