class Job
  include MongoMapper::Document

    key   :description, String
    #key   :credentialrules, String
    #key   :credentials,  Array
    #key   :skills,  Array

    timestamps!

    validates_presence_of :description
    #validates_presence_of :credentialrules
    
end
