class EducatorController < ApplicationController

	def addInstitution
		unless(params[:cancel].nil?)
			redirect_to :action 					=>		"educatorLogin"
		end
				
		unless(params[:add].nil?)
			insName									=		params[:name]
			insAddress	 			  				= 		params[:address]
			insWebsite	 			  				= 		params[:website]
			insCity			  						= 		params[:city]
			insState 			  					= 		params[:state]
			insCountry			  					= 		params[:country]
			insZip		 			  				= 		params[:zip]
			insPhoneNumber 		  					= 		params[:phoneNumber]
			
			unless(insName.nil?)
			    ins_data  							= 		Institution.find_by_name(insName.to_s)
				if(ins_data.nil?)
				    institute						=		Institution.create(:name => insName, :website => insWebsite, :address => insAddress, :city => insCity, :state => insState, :country => insCountry, :zip => insZip, :phoneNumber => insPhoneNumber)
					if(institute.save == true)
						session[:institionID]		=		institute.id
						redirect_to :action 		=>		"institutionUserList"
					end	  
				else
					@msg     						= 		"Institution already exist"
					redirect_to :action 			=>		"addInstitution"
				end  
			end	 
		end
	end 
	
	def institutionUserList
		@institutionDetails							=		Array.new
		@educatorList  								= 		Array.new
		
		unless(params[:add].blank?)
			redirect_to :action 					=>		"addEducator"
        end
		
		if(session[:educatorID])
			value									=		session[:educatorID]
		else
			value									=		session[:institionID]
		end	
	
		institute									=		Institution.find_by_id(value.to_s)
		@institutionDetails.push("instituteName" => institute.name , "instituteCity" => institute.city , "instituteState" => institute.state, "instituteID" => value.to_s)

		@cnt_data  									= 		Educator.where(:institutionID => value.to_s).all
		if(@cnt_data)
			@cnt_data.each do |val|
								role				= 		(Educatorrole.find_by_id(val.educatorRole)).educatorRole
								permission 			=		(Educatorpermission.find_by_id(val.educatorPermission)).educatorPermission
								@educatorList.push("name" => val.firstName + ' ' + val.lastName , "email" => val.email , "educatorid" => val.id, "educatorRole" => role, "educatorPermission" => permission )
						   end
		end	
	end
	
	def addEducator
		@roleArray               					= 		Hash.new
		Educatorrole.all.each do |value|
								@roleArray[value.educatorRole] 				= 		value.id
						  end	
		@permissionArray           					= 		Hash.new
		Educatorpermission.all.each do |value|
								@permissionArray[value.educatorPermission] 	= 		value.id
						    end
						    
		if(session[:educatorID])
			value									=		session[:educatorID]
		else
			value									=		session[:institionID]
		end
				  
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"institutionUserList"
        end
        
        unless(params[:add].blank?)
			firstName	 			  				= 		params[:firstName]
			lastName	 			  				= 		params[:lastName]
			email	 			  					= 		params[:email]
			userName								=		params[:userName]
			password 			  					= 		params[:password]
			educatorRole		  					= 		params[:educatorRole]
			educatorPermission	  					= 		params[:educatorPermission]
			
			unless(userName.nil?)
				educator							=		Educator.new(:firstName => firstName, :lastName => lastName.to_s, :email => email, :educatorUserName => userName, :educatorPassword => password , :educatorRole => educatorRole , :educatorPermission => educatorPermission , :institutionID => value.to_s)
				if(educator.save == true)
					@msg     						= 		"successfully inserted"
					redirect_to :action 			=>		"institutionUserList"
				end
			end
        end
	end
	
	def educatorLogin
		unless(params[:educatorLogin].nil?)
			eductorUserName							=		params[:eductorUserName]
			eductorPassword					    	=		params[:eductorPassword]
			unless(eductorUserName.nil?)
				educator_data  						= 		Educator.find_by_educatorUserName(eductorUserName)
				unless(educator_data.nil?)
					password						=		educator_data.educatorPassword
					unless(password.nil?)
						if(eductorPassword == password)
							session[:userid]		=		educator_data.id
							session[:institionID]	=		educator_data.institutionID
							redirect_to :action 	=>		"courseList"
						else
							@msg					=		"username or password is incorrect"
						end 		
					end
				else
					@msg							=		"username or password is incorrect"	
				end	
			else
				@msg								=		"Please enter usernmae"	
			end	
		end
	end
	
	def editInstitution
		@institutionData  							= 		Array.new
		@userID										=		params[:insID]
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"institutionUserList"
        end				    		
		unless(params[:insID].blank?)
			data									=		Institution.find_by_id(params[:insID].to_s)
			@institutionData.push("name" => data.name, "website" => data.website, "address" => data.address, "city" => data.city, "state" => data.state, "country" => data.country, "zip" => data.zip, "phoneNumber" => data.phoneNumber)
		end
	end
	
	def updateInstitution
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"institutionUserList"
        end	
		unless(params[:update].nil?)
			insName									=		params[:name]
			insAddress	 			  				= 		params[:address]
			insWebsite	 			  				= 		params[:website]
			insCity			  						= 		params[:city]
			insState 			  					= 		params[:state]
			insCountry			  					= 		params[:country]
			insZip		 			  				= 		params[:zip]
			insPhoneNumber 		  					= 		params[:phoneNumber]
			unless(params[:prospect].nil?)
				institution							=		Institution.find_by_id(params[:prospect].to_s)
				unless(institution.nil?)
					institution.name 				= 		insName
					institution.address				= 		insAddress
					institution.website 			= 		insWebsite
					institution.city 				= 		insCity
					institution.state				= 		insState
					institution.country				= 		insCountry
					institution.zip					= 		insZip
					institution.phoneNumber			= 		insPhoneNumber
					
					result 							= 		institution.save
					if(result == true)
						redirect_to :action 		=>		"institutionUserList"
					end
				end	
			end
		end	
	end
	
	def editEducator
		@userID										=		params[:prospect]	
		@educatorData  								= 		Array.new
		@roleArray               					= 		Hash.new
		Educatorrole.all.each do |value|
								@roleArray[value.educatorRole] 					= 		value.id
						  end	
		@permissionArray           					= 		Hash.new
		Educatorpermission.all.each do |value|
								@permissionArray[value.educatorPermission] 		= 		value.id
						    end
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"institutionUserList"
        end				    		
		unless(params[:prospect].blank?)
			data									=		Educator.find_by_id(params[:prospect].to_s)
			@educatorData.push("firstName" => data.firstName, "email" => data.email, "lastName" => data.lastName, "institutionID" => data.id)
			@userRole								=		data.educatorRole
			@permission								=		data.educatorPermission
		end
	end
	
	def updateEducator
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"institutionUserList"
        end	
		unless(params[:update].nil?)
			firstName	 			  				= 		params[:firstName]
			lastName	 			  				= 		params[:lastName]
			email	 			  					= 		params[:email]
			educatorRole		  					= 		params[:educatorRole]
			educatorPermission	  					= 		params[:educatorPermission]
			unless(params[:prospect].nil?)
				educator							=		Educator.find_by_id(params[:prospect].to_s)
				unless(educator.nil?)
					educator.firstName 				= 		firstName
					educator.lastName				= 		lastName
					educator.email 					= 		email
					educator.educatorPermission 	= 		educatorPermission
					educator.educatorRole			= 		educatorRole
					result 							= 		educator.save
					if(result == true)
						@msg     					= 		"successfully inserted"
						redirect_to :action 		=>		"institutionUserList"
					end
				end	
			end
		end	
	end
	
	def addCourse
		@skill				               			= 		Hash.new
		@subskill				               		= 		Hash.new
		@skill["Select Category"]					=		""
		@subskill["Select Specialty"]				=		""		
		Skill.where(:parentid => "0").all.each do |value|
												   @skill[value.name] 				= 		value.id
											   end
		unless(params[:Submit].blank?)
			courseTitle	 			  				= 		params[:courseTitle]
			cost		 			  				= 		params[:cost]
			courseRegister 			  				= 		params[:courseRegister]
			enrollmentStartDate		  				= 		params[:enrollmentStartDate]
			enrollmentEndDate		  				= 		params[:enrollmentEndDate]
			courseIDNumber 			  				= 		params[:courseIDNumber]
			courseStartDate			  				= 		params[:courseStartDate]
			courseEndDate 			  				= 		params[:courseEndDate]
			courseMeets	 			  				= 		params[:courseMeets]
			noOfStudents 			  				= 		params[:noOfStudents]
			skills		 			  				= 		params[:skill]
			courseDescription		  				= 		params[:courseDescription]
			unless(session[:institionID].nil?)
				course								=		Course.new(:institutionid => session[:institionID].to_s, :title => courseTitle.to_s, :cost => cost, :startdate => courseStartDate, :endDate => courseEndDate , :courseIdNo => courseIDNumber , :courseRegisterURL => courseRegister , :enrollStartPeriod => enrollmentStartDate, :enrollEndPeriod => enrollmentEndDate , :courseMeet => courseMeets, :numberStudent => noOfStudents , :description => courseDescription)
				if(course.save == true)
					courseID						=		course.id
					skills.each do |val|
									Skill.push({:id => val.to_s}, :course => courseID.to_s)
								end
					redirect_to :action 			=>		"courseList"			
				end
			end
        end									   
	end
	
	def editCourse
		@courseData  								= 		Array.new
		@courseID									=		params[:courseID]
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"courseList"
        end				    		
		unless(params[:courseID].blank?)
			data									=		Course.find_by_id(params[:courseID].to_s)
			@courseData.push("title" => data.title, "startdate" => data.startdate, "cost" => data.cost, "endDate" => data.endDate, "courseIdNo" => data.courseIdNo, "courseRegisterURL" => data.courseRegisterURL, "enrollStartPeriod" => data.enrollStartPeriod, "enrollEndPeriod" => data.enrollEndPeriod, "courseMeet" => data.courseMeet, "numberStudent" => data.numberStudent, "description" => data.description)
		end
	end
	
	def updateCourse
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"courseList"
        end	
		unless(params[:update].nil?)
			courseTitle	 			  				= 		params[:courseTitle]
			cost		 			  				= 		params[:cost]
			courseRegister 			  				= 		params[:courseRegister]
			enrollmentStartDate		  				= 		params[:enrollmentStartDate]
			enrollmentEndDate		  				= 		params[:enrollmentEndDate]
			courseIDNumber 			  				= 		params[:courseIDNumber]
			courseStartDate			  				= 		params[:courseStartDate]
			courseEndDate 			  				= 		params[:courseEndDate]
			courseMeets	 			  				= 		params[:courseMeets]
			noOfStudents 			  				= 		params[:noOfStudents]
			unless(params[:courseID].nil?)
				course								=		Course.find_by_id(params[:courseID].to_s)
				unless(course.nil?)
					course.title 					= 		courseTitle
					course.cost						= 		cost
					course.courseRegisterURL 		= 		courseRegister
					course.enrollStartPeriod 		= 		enrollmentStartDate
					course.enrollEndPeriod			= 		enrollmentEndDate
					course.courseIdNo 				= 		courseIDNumber
					course.startdate				= 		courseStartDate
					course.endDate 					= 		courseEndDate
					course.courseMeet 				= 		courseMeets
					course.numberStudent			= 		noOfStudents
					result 							= 		course.save
					if(result == true)
						@msg     					= 		"successfully inserted"
						redirect_to :action 		=>		"courseList"
					end
				end	
			end
		end	
	end
	
	def courseList
		@courseListArray							=		Array.new
		@institutionDetails							=		Array.new
		
		institute									=		Institution.find_by_id(session[:institionID].to_s)
		@institutionDetails.push("instituteName" => institute.name , "instituteCity" => institute.city , "instituteState" => institute.state, "instituteID" => session[:institionID].to_s)

		courseList 									= 		Course.where(:institutionid => session[:institionID].to_s).all
		if(courseList)
			courseList.each do |val|
								@courseListArray.push("courseDate" => val.startdate + ' - ' + val.endDate , "title" => val.title , "courseMeet" => val.courseMeet, "numberStudent" => val.numberStudent, "courseID" => val.id)
						   end
		end	
		
		unless(params[:add].blank?)
			redirect_to :action 					=>		"addCourse"
        end
	end
end
