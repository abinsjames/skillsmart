class Prospect
  include MongoMapper::Document

    key  :employeeusername, String  
	key  :employeepassword, String 
	key  :employeefirstname, String
	key  :employeelastname, String 	
	key  :employeeaddress, String
	key  :city, String
	key  :state, String
	key  :country, String
	key  :twitter, String
	key  :linkedin, String
	key  :zip, String
	key  :employeeemail, String
	key  :employeemobile, Integer
    key  :jobsapplied,  Array
    key  :invited,  Array 
    key  :jobswatched, Array   	
	
	
    timestamps!

    validates_presence_of :employeeusername
    validates_presence_of :employeepassword
    validates_presence_of :employeefirstname
    validates_presence_of :employeelastname
    validates_presence_of :employeeaddress    
    validates_presence_of :employeeemail
end
