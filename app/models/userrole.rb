class Userrole
  include MongoMapper::Document

    key :rolename, String  
    
    timestamps!

    validates_presence_of :rolename
    
end
