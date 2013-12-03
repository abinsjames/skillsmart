class Educatorpermission
  include MongoMapper::Document

    key :educatorPermission, String  
	
	
	
    timestamps!

    validates_presence_of :educatorPermission
    
end
