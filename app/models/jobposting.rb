class Jobposting
  include MongoMapper::Document

	key  :description, String 
	key  :details, String 
	key  :address, String
	key  :city, String
	key  :state, String
	key  :zip, Integer
	key  :postingcompany, String
	key  :hrmanager, String
	key  :manager, String
	key  :reviewer, String
	key  :jobid, String
	key  :dateopen, String 
	key  :jobtype, String
	key  :dateclose, String 
	key  :numpositions, Integer 
	key  :salary, Integer 
	key	 :hiringauthority, String 
	key	 :status, Integer, :default => 1 	
	key  :additionalskills,  Array
	key  :allowedcredentials,  Array
    key  :requiredskills,  Array
    key  :desiredskills,  Array
    key  :skillsrating,  Array
    key  :jobSeeker,  Array
    
	many :rating
	
    timestamps!

    validates_presence_of :postingcompany
    validates_presence_of :jobid
    validates_presence_of :description
    validates_presence_of :dateopen
    validates_numericality_of :numpositions
    validates_numericality_of :salary
    validates_presence_of :hiringauthority
    validates_presence_of :status
end
