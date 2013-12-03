class Portfolio
  include MongoMapper::Document

    key   :ownerid, String
    many  :workhistory
    many  :education
    many  :resume

    timestamps!

    validates_presence_of :ownerid
    
end
