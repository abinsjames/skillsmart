Employee::Application.routes.draw do

	match "home/user_register" 					=>  	"employee#add_employee"
	match "/home/index" 						=> 		"home#index"
	match "/home/list_employee" 				=>  	"home#list_employee"
	match "/home/add_employee" 					=>  	"home#add_employee"
	match "/home/home/index"					=>		"home#index"
	match "/home/logout"						=>		"home#logout"
	match "/home/jobOpening"					=>		"home#jobOpening"
	match "/home/jobPrerequisites"				=>		"home#jobPrerequisites"
	match "/home/jobSkills"						=>		"home#jobSkills"
	match "/home/companyRegistration"			=>		"home#companyRegistration" 
	match "/home/companyUserList"				=>		"home#companyUserList" 
	match "/home/addUsers"						=>		"home#addUsers" 
	match "/home/dashBoard"						=>		"home#dashBoard"
	match "/home/rankJob"						=>		"home#rankJob"
	match "/home/postPosition"					=>		"home#postPosition"
	match "/home/popupPostPosition"				=>		"home#popupPostPosition" 
	match "/home/availableCandidate"			=>		"home#availableCandidate"
	match "/home/candidateComparison"			=>		"home#candidateComparison"
	match "/home/candidateEvaluation"			=>		"home#candidateEvaluation"
	match "/home/candidateSelection"			=>		"home#candidateSelection"
	match "/home/portfolio"						=>		"home#portfolio"
	match "/home/systemJob"						=>		"home#systemJob"
	match "/home/employerLogin"					=>		"home#employerLogin"   
	match "/home/jobPosting"					=>		"home#jobPosting"
	match "/home/addRequiredSkills"				=>		"home#addRequiredSkills"
	match "/home/removeRequiredSkills"			=>		"home#removeRequiredSkills"
	match "/home/desiredOrRequired"				=>		"home#desiredOrRequired"
	match "/home/skillRatingRankVal"			=>		"home#skillRatingRankVal"
	match "/home/skillRatingPriorityVal"		=>		"home#skillRatingPriorityVal"
	match "/home/rankJobDone"					=>		"home#rankJobDone"
	match "/home/addPostPosition"				=>		"home#addPostPosition"
	match "/home/getSkillID"					=>		"home#getSkillID"
	match "/home/popSecondPre"					=>		"home#popSecondPre"
	match "/home/PopThirdPre"					=>		"home#PopThirdPre"	
	match "/home/addPrequisite"					=>		"home#addPrequisite"	
	match "/home/employeeSearch"				=>		"home#employeeSearch"	
	match "/home/jobSeekerProfile"				=>		"home#jobSeekerProfile"	
	match "/home/candidateSearch"				=>		"home#candidateSearch"	
	match "/home/selectionPage"					=>		"home#selectionPage"	
	match "/home/available"						=>		"home#available"
	match "/home/addInstitution"				=>		"home#addInstitution"	
	match "/home/addCourse"						=>		"home#addCourse"
	match "/home/listInstitution"				=>		"home#listInstitution"
	match "/home/listCompanyType"				=>		"home#listCompanyType"
	match "/home/addCompanyType"				=>		"home#addCompanyType"
	match "/home/jobSeekerContact"				=>		"home#jobSeekerContact"	
	match "/home/editUser"						=>		"home#editUser"			
	match "/home/updateUser"					=>		"home#updateUser"	
	match "/home/editCompany"					=>		"home#editCompany"			
	match "/home/updateCompany"					=>		"home#updateCompany"
	match "/home/editJobDetails"				=>		"home#editJobDetails"			
	match "/home/updateJobDetails"				=>		"home#updateJobDetails"
	match "/home/edit"							=>		"home#edit"
	match "/home/editPrerequsite"				=>		"home#editPrerequsite"
	match "/home/updatePrerequsite"				=>		"home#updatePrerequsite" 
	match "/home/editJobSkill"					=>		"home#editJobSkill"
	match "/home/connectCandidate"				=>		"home#connectCandidate"	
	match "/home/jobPostingNew"					=>		"home#jobPostingNew" 
	match "/home/preRequsiteNew"				=>		"home#preRequsiteNew"
	match "/home/homePage"						=>		"home#homePage" 
	match "/home/signout"						=>		"home#signout"
	match "/home/csv_method"					=>		"home#csv_method"
	match "/home/demo"							=>		"home#demo"	
	match "/home/login"							=>		"home#login" 
	match "/home/popupForSkill"					=>		"home#popupForSkill"
	match "/home/popupForPrerequisite"			=>		"home#popupForPrerequisite"
	
	
	
	match "/jobseeker/courseDetails"			=>		"employee#courseDetails"	
	match "/jobseeker/addEmployee"				=>		"employee#addEmployee"
	match "/jobseeker/login"					=>		"employee#login"
	match "/jobseeker/addSkill"					=>		"employee#addSkill"
	match "/jobseeker/addSubSkill"				=>		"employee#addSubSkill"
	match "/jobseeker/listSkill"				=>		"employee#listSkill"
	match "/jobseeker/addMyskillsPortfolio"		=>		"employee#addMyskillsPortfolio" 
	match "/jobseeker/myskillsPortfolio"		=>		"employee#myskillsPortfolio"
	match "/jobseeker/accessMyskill"			=>		"employee#accessMyskill"
	match "/jobseeker/myCertificates"			=>		"employee#myCertificates"
	match "/jobseeker/myExamples"				=>		"employee#myExamples"
	match "/jobseeker/myReferences"				=>		"employee#myReferences"
	match "/jobseeker/myWorkHistory"			=>		"employee#myWorkHistory"
	match "/jobseeker/myResume"					=>		"employee#myResume" 
	match "/jobseeker/myEducation"				=>		"employee#myEducation"  
	match "/jobseeker/myWorkHistoryPopup"		=>		"employee#myWorkHistoryPopup"
	match "/jobseeker/myResumePopup"			=>		"employee#myResumePopup"
	match "/jobseeker/myEducationPopup"			=>		"employee#myEducationPopup"    
	match "/jobseeker/myJobAssessment"			=>		"employee#myJobAssessment"
	match "/jobseeker/myJobFinder"				=>		"employee#myJobFinder"
	match "/jobseeker/myskillSmart"				=>		"employee#myskillSmart"
	match "/jobseeker/registerSuccess"			=>		"employee#registerSuccess" 
	match "/jobseeker/portfolio"				=>		"employee#portfolio"
	match "/jobseeker/add"						=>		"employee#add"
	match "/jobseeker/popSecond"				=>		"employee#popSecond"	
	match "/jobseeker/add"						=>		"employee#add"
	match "/jobseeker/maps"						=>		"employee#maps"  
	match "/jobseeker/myWorkPopup"				=>		"employee#myWorkPopup"
	match "/jobseeker/myResum"					=>		"employee#myResum"
	match "/jobseeker/myEdu"					=>		"employee#myEdu"
	match "/jobseeker/myCert"					=>		"employee#myCert"
	match "/jobseeker/myEg"						=>		"employee#myEg"
	match "/jobseeker/myRefer"					=>		"employee#myRefer"
	match "/jobseeker/getSecond"				=>		"employee#getSecond"
	match "/jobseeker/addThirdLevel"			=>		"employee#addThirdLevel"  
	match "/jobseeker/PopThird"					=>		"employee#PopThird"  
	match "/jobseeker/jQueryaccessMyskill"		=>		"employee#jQueryaccessMyskill"
	match "/jobseeker/distance"					=>		"employee#distance"
	match "/jobseeker/demo"						=>		"employee#demo"	
	match "/jobseeker/changeProficency"			=>		"employee#changeProficency"	
	match "/jobseeker/changeExperience"			=>		"employee#changeExperience" 
	match "/jobseeker/addAskill"				=>		"employee#addAskill"
	match "/jobseeker/myskillsForAddMyskill"	=>		"employee#myskillsForAddMyskill"
	match "/jobseeker/addPrequisite"			=>		"employee#addPrequisite"
	match "/jobseeker/addSubPrequisite"			=>		"employee#addSubPrequisite"
	match "/jobseeker/addThirdLevelPrequisite"	=>		"employee#addThirdLevelPrequisite"
	match "/jobseeker/listPrequisite"			=>		"employee#listPrequisite"
	match "/jobseeker/getSecondPre"				=>		"employee#getSecondPre" 
	match "/jobseeker/applyJob"					=>		"employee#applyJob"
	match "/jobseeker/dashboard"				=>		"employee#dashboard" 
	match "/jobseeker/myPortfolio"				=>		"employee#myPortfolio"
	match "/jobseeker/myWorkDashboard"			=>		"employee#myWorkDashboard" 
	match "/jobseeker/myEducationDashboard"		=>		"employee#myEducationDashboard"
	match "/jobseeker/openApplication"			=>		"employee#openApplication"
	match "/jobseeker/filter"					=>		"employee#filter" 
	match "/jobseeker/popupApplyJob"			=>		"employee#popupApplyJob" 
	match "/jobseeker/addMyRating"				=>		"employee#addMyRating" 
	match "/jobseeker/editMyProfile"			=>		"employee#editMyProfile"  
	match "/jobseeker/portfolioNew"				=>		"employee#portfolioNew" 
	match "/jobseeker/myResumeDashboard"		=>		"employee#myResumeDashboard"
	match "/jobseeker/watchedJobs"				=>		"employee#watchedJobs" 
	match "/jobseeker/myWatchedJobs"			=>		"employee#myWatchedJobs"	
	match "/jobseeker/updateMyProfile"			=>		"employee#updateMyProfile" 
	match "/jobseeker/myProfile"				=>		"employee#myProfile"  
	match "/jobseeker/editEducation"			=>		"employee#editEducation" 
	match "/jobseeker/updateEducation"			=>		"employee#updateEducation"
	match "/jobseeker/editWorkHistory"			=>		"employee#editWorkHistory" 
	match "/jobseeker/updateWorkHistory"		=>		"employee#updateWorkHistory"
	match "/jobseeker/skillvalidate"			=>		"employee#skillvalidate"	
	match "/jobseeker/editskill"				=>		"employee#editskill"	
	match "/jobseeker/addSkillNew"				=>		"employee#addSkillNew"
	match "/jobseeker/popupForSkill"			=>		"employee#popupForSkill"
	
	match "/educator/addInstitution"			=>		"educator#addInstitution"
	match "/educator/institutionUserList"		=>		"educator#institutionUserList"
	match "/educator/educatorLogin"				=>		"educator#educatorLogin"
	match "/educator/editInstitution"			=>		"educator#editInstitution"
	match "/educator/editEducator"				=>		"educator#editEducator"
	match "/educator/addEducator"				=>		"educator#addEducator" 
	match "/educator/updateEducator"			=>		"educator#updateEducator"
	match "/educator/addCourse"					=>		"educator#addCourse"  
	match "/educator/courseList"				=>		"educator#courseList"
	match "/educator/editInstitution"			=>		"educator#editInstitution"  
	match "/educator/updateInstitution"			=>		"educator#updateInstitution"	
	match "/educator/editCourse"				=>		"educator#editCourse"
	match "/educator/updateCourse"				=>		"educator#updateCourse"
	
	  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
    root :to => 'home#homePage'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
