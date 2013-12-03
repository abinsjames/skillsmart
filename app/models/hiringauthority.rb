class Hiringauthority
  include MongoMapper::Document

    key :authority, String  
    
    timestamps!

    validates_presence_of :authority
    
end
