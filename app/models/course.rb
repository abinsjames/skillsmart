class Course
  include MongoMapper::Document

    key :institutionid, String
    key :title, String
    key :startdate, String
    key :cost, String    
    key :endDate, String
    key :courseIdNo, String
    key :courseRegisterURL, String
    key :enrollStartPeriod, String
    key :enrollEndPeriod, String
    key :courseMeet, String
    key :numberStudent, String
    key :description, String
    key :timerequired, String
    

    timestamps!

    
end
