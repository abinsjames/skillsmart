class Skill
  include MongoMapper::Document

    key :parentid, String , :default => "0" 
    key :name, String
    key :description, String
    key :definedby, String, :default => "0"
    key :course,  Array


    timestamps!

	validates_presence_of :parentid
    validates_presence_of :name
    validates_presence_of :description
    
end
