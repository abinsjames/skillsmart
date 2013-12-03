class Educator
  include MongoMapper::Document

    key :institutionID, String  
	key :firstName, String
	key :lastName, String 
	key :email, String 
	key :educatorUserName, String 
	key :educatorPassword, String 
	key :educatorPermission, String 
	key :educatorRole, String
	
    timestamps!

    validates_presence_of :institutionID
    validates_presence_of :firstName
    
end
