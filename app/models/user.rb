class User
  include MongoMapper::Document

    key :acctname, String  
    key :employerid, String 
	key :password, String 
	key :passwordsalt, String, :default => "dg585gh5h5"
	key :expired, Boolean , :default => "false" 
	key :email, String 
	key :permission, String 
	key :roleid, String 
	key :firstname, String 
	key :lastname, String 
	 
    timestamps!

    validates_presence_of :acctname
    validates_presence_of :employerid
    validates_presence_of :password
    validates_presence_of :passwordsalt
    validates_presence_of :expired
    validates_presence_of :email
    validates_presence_of :permission
    validates_presence_of :roleid
    validates_presence_of :firstname
    validates_presence_of :lastname    
end
