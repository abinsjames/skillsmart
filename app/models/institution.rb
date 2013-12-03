class Institution
  include MongoMapper::Document

    key :name, String
    key :website, String
    key :address, String
    key :city, String
    key :state, String
    key :country, String
    key :zip, String
    key :phoneNumber, String
    key :location, String
    

    timestamps!

	validates_presence_of :name	
    
end
