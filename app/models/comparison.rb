class Comparison
  include MongoMapper::Document

    key :name, String  
    key :prerequisite, Integer 
	key :skill, Integer 
	key :noPos, Integer 
	key :noOrg, Integer 
	key :averageScore, Integer 
	
	 
    timestamps!

    validates_presence_of :name
    validates_numericality_of :prerequisite
    validates_numericality_of :skill
    validates_numericality_of :noPos
    validates_numericality_of :noOrg
    validates_numericality_of :averageScore
   
end
