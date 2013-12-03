class Permission
  include MongoMapper::Document

    key :permission, String  
    
    timestamps!

    validates_presence_of :permission
    
end
