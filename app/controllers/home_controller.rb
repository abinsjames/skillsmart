class HomeController < ApplicationController
	before_filter :require_login, :only => [:list_employee]
	skip_before_filter :verify_authenticity_token, :only => [:rankJobDone]
	def index

		unless(params[:login].nil?)
			empUsName							=		params[:empUsName]
			empPass							    =		params[:empPass]
			
			unless(empUsName.nil?)
				emp_data  						= 		DdEmployeeregister.find_by_employeeUserName(empUsName)
				unless(emp_data.nil?)
					password					=		emp_data.employeePassword
					unless(password.nil?)
						if(empPass == password)
							session[:username]	=		empUsName
							redirect_to :action =>		"companyRegistration"
						else
							session[:log]		=		"username or password is incorrect"
							redirect_to :action =>		"index"
							
						end 		
					end
				else
					session[:log]				=		"username or password is incorrect"	
					redirect_to :action 		=>		"index"
				end	
			else
				session[:log]					=		"Please enter usernmae"	
				redirect_to :action 			=>		"index"	
			end	
		end
		
	end 
	
	def add_employee

		unless(params[:cancel].nil?)
			redirect_to :action 				=>		"list_employee"
		end
		
		unless(params[:add].nil?)
			  empName 			  				= 		params[:empName]
			  empAge							=		params[:empAge]
			  empAdd							=		params[:empAdd]
			  empUsName							=		params[:empUsName]
			  empPass							=		params[:empPass]
			  
			  unless(empUsName.nil?)
				  emp_data  					= 		DdEmployeeregister.find_by_employeeUserName(empUsName)
				  
				  if(emp_data.nil?)
					  employ  					= 		DdEmployeeregister.new(:employeeName => empName.capitalize, :employeeAge => empAge, :employeeAddress => empAdd, :employeeUserName => empUsName, :employeePassword => empPass)
					  if(employ.save == true)
						  @msg     				= 		"successfully inserted"
						  redirect_to :action 	=>		"index"
					  end	  
				  else
					  session[:lmsg]     		= 		"Username already exist"
					  redirect_to :action 		=>		"add_employee"
				  end  
			  end	  
		end
	end             


	def list_employee
	
		unless(params[:add].blank?)
              redirect_to :action 				=>		"add_employee"
        end
	
		@count									=		0
		@cntArray      							= 		Array.new
		@totalcnt  								= 		DdEmployeeregister.all.count
		cnt_data  								= 		DdEmployeeregister.sort(:employeeName.desc).all
		 unless(cnt_data.nil?)
			cnt_data.each do |val|
								@cntArray.push(val.employeeName)
						 end
	     end	
	end
	
	def logout
		session[:username] 						= 		nil
		redirect_to :action 					=>		"index"
	end
	
	def preRequsiteNew
		unless(params[:add].nil?)
			jobID										=		params[:jobIDVal]
			unless(jobID.nil?)
				data									=		Jobposting.find_by_id(jobID)
				unless(data.nil?)
					data.status							=		2
					result  							= 		data.save
					if(result == true)
						redirect_to :action 		=>		"jobPostingNew" , :jobID => jobID
					end	
				end	
			end	
		end
	end
	
	def popupForSkill
		@skill				               				= 		Hash.new
		@subskill				               			= 		Hash.new
		@thirdSkill				               			= 		Hash.new
		@skill["Select Category"]						=		""
		@subskill["Select Speciality"]					=		""		
		Skill.where(:parentid => "0").all.each do |value|
													@skill[value.name] 				= 		value.id
												end
		@id												=		params[:id].to_s										
	end
	
	def popupForPrerequisite
		@prerequsite		               				= 		Hash.new
		@subprerequsite			               			= 		Hash.new
		@thirdprerequsite		               			= 		Hash.new
		@prerequsite["Select Category"]					=		""
		@subprerequsite["Select Specialty"]				=		""		
		Prequisite.where(:parentid => "0").all.each do |value|
													   @prerequsite[value.name] 				= 		value.id
												   end
		@id												=		params[:id].to_s										   
	end											   
	
	def demo
		postingcompany									=		session[:postingcompany]
		@hiringAuthority               					= 		Hash.new
		@jobCategory	               					= 		Hash.new
		@hrManager	               						= 		Hash.new
		@manager	               						= 		Hash.new
		@reviewer	               						= 		Hash.new
		@dataARY										=		Array.new
		
		@jobCategory["Select Job Category"] 			=		""
		User.where(:employerid => session[:postingcompany]).all.each do |value|
							@hiringAuthority[value.firstname + ' ' +  value.lastname] 				= 		value.id
					  end
		Job.all.each do |val|
							@jobCategory[val.description] 					= 		val.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711c2f1bb55071c001c55").all.each do |value|
							@hrManager[value.firstname + ' ' +  value.lastname] 						= 		value.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711ebf1bb55071c001c56").all.each do |value|
							@manager[value.firstname + ' ' +  value.lastname] 							= 		value.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711fdf1bb55071c001c57").all.each do |value|
							@reviewer[value.firstname + ' ' +  value.lastname] 						= 		value.id
					 end
	end
	
	def jobPostingNew
		postingcompany									=		session[:postingcompany]
		@hiringAuthority               					= 		Hash.new
		@jobCategory	               					= 		Hash.new
		@hrManager	               						= 		Hash.new
		@manager	               						= 		Hash.new
		@reviewer	               						= 		Hash.new
		@dataARY										=		Array.new
		
		@jobCategory["Select Job Category"] 			=		""
		User.where(:employerid => session[:postingcompany]).all.each do |value|
							@hiringAuthority[value.firstname + ' ' +  value.lastname] 				= 		value.id
					  end
		Job.all.each do |val|
							@jobCategory[val.description] 					= 		val.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711c2f1bb55071c001c55").all.each do |value|
							@hrManager[value.firstname + ' ' +  value.lastname] 						= 		value.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711ebf1bb55071c001c56").all.each do |value|
							@manager[value.firstname + ' ' +  value.lastname] 							= 		value.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711fdf1bb55071c001c57").all.each do |value|
							@reviewer[value.firstname + ' ' +  value.lastname] 						= 		value.id
					 end
					 
		@skill				               				= 		Hash.new
		@subskill				               			= 		Hash.new
		@thirdSkill				               			= 		Hash.new
		@jobID											=		params[:jobID]
		unless(params[:jobID].nil?)
			@msg										=		"Successfully posted the job.. now you can define prerequsite and skills"
			data										=		Jobposting.find_by_id(@jobID)
			@jobName									=		data.description	
			hire										=		data.hiringauthority
			hire_data									=		Hiringauthority.where(:id => hire.to_s)
			hire_data.each do |valu|
							  hireval					=		valu.authority
							  @hirevalues 				= 		hireval.split(',')
							 end
							 
				 
			@dataARY.push("jobName" => data.description, "details" => data.details, "numOfPositions" => data.numpositions, "openDate" => data.dateopen, "close" => data.dateclose, "salary" => data.salary, "address" => data.address, "city" => data.city, "state" => data.state, "zip" => data.zip)
			@userRole									=		data.jobid
		end	
		
		unless(params[:add].nil?)
			title	 			  						= 		params[:title]
			openings 			  						= 		params[:openings]
			opdate	 			  						= 		params[:opdate]
			cldate	 			  						= 		params[:cldate]			
			salary	 			  						= 		params[:salary]
			address 			  						= 		params[:address]
			city	 			  						= 		params[:city]
			state	 			  						= 		params[:state]
			zip		 			  						= 		params[:zip]
			jobCategory			  						= 		params[:jobCategory]
			tagAry  									=  		params[:sel_tagstores]
			jobType  									=  		params[:type]
			
			hrmanager			  						= 		params[:hrManager]
			manager				  						= 		params[:manager]
			reviewer			  						= 		params[:reviewer]
			details										=		params[:details]
			
			unless(tagAry.nil?)
				tagsval  								= 		tagAry.join(',')
			end
			unless(tagsval.nil?)
				hiring  								= 		Hiringauthority.new(:authority => tagsval)
				
				if(hiring.save == true)
					hir 								= 		Hiringauthority.sort(:created_at.desc).all
					hiringid							=		hir[0].id
					employ  							= 		Jobposting.create(:jobid => jobCategory , :jobtype => jobType , :details => details , :postingcompany => postingcompany , :hiringauthority => hiringid, :description => title, :dateopen => opdate, :dateclose => cldate, :numpositions => openings, :salary => salary, :address => address, :city => city, :state => state, :zip => zip, :reviewer => reviewer, :manager => manager, :hrmanager => hrmanager)
					if(employ)
						@msg     						= 		"successfully inserted"
						redirect_to :action 			=>		"jobPostingNew" , :jobID => employ.id
					end
				end
			end	
		end		
				
		@skill["Select Category"]						=		""
		@subskill["Select Specialty"]					=		""		
		Skill.where(:parentid => "0").all.each do |value|
												   @skill[value.name] 				= 		value.id
											   end	
											   
		
		
		@prerequsite		               				= 		Hash.new
		@subprerequsite			               			= 		Hash.new
		@thirdprerequsite		               			= 		Hash.new
		@preARY					               			= 		Array.new
		@jobID											=		params[:jobID]
		@prerequsite["Select Category"]					=		""
		@subprerequsite["Select Specialty"]			=		""		
		Prequisite.where(:parentid => "0").all.each do |value|
													   @prerequsite[value.name] 				= 		value.id
												   end									   		 
	end
	
	def jobOpening
		postingcompany									=		session[:postingcompany]
		@hiringAuthority               					= 		Hash.new
		@jobCategory	               					= 		Hash.new
		@hrManager	               						= 		Hash.new
		@manager	               						= 		Hash.new
		@reviewer	               						= 		Hash.new
		
		@jobCategory["Select Job Category"] 			=		""
		@hrManager["Select Job Category"] 				=		""
		@manager["Select Job Category"] 				=		""
		@reviewer["Select Job Category"] 				=		""
		User.where(:employerid => session[:postingcompany]).all.each do |value|
							@hiringAuthority[value.acctname] 				= 		value.id
					  end
		Job.all.each do |val|
							@jobCategory[val.description] 					= 		val.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711c2f1bb55071c001c55").all.each do |val|
							@hrManager[val.acctname] 						= 		val.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711ebf1bb55071c001c56").all.each do |val|
							@manager[val.acctname] 							= 		val.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711fdf1bb55071c001c57").all.each do |val|
							@reviewer[val.acctname] 						= 		val.id
					 end			 			 			 			  
						  
		unless(params[:add].nil?)
			title	 			  						= 		params[:title]
			openings 			  						= 		params[:openings]
			opdate	 			  						= 		params[:opdate]
			cldate	 			  						= 		params[:cldate]			
			salary	 			  						= 		params[:salary]
			address 			  						= 		params[:address]
			city	 			  						= 		params[:city]
			state	 			  						= 		params[:state]
			zip		 			  						= 		params[:zip]
			jobCategory			  						= 		params[:jobCategory]
			tagAry  									=  		params[:sel_tagstores]
			jobType  									=  		params[:type]
			
			hrmanager			  						= 		params[:hrManager]
			manager				  						= 		params[:manager]
			reviewer			  						= 		params[:reviewer]
			details										=		params[:details]
			
			unless(tagAry.nil?)
				tagsval  								= 		tagAry.join(',')
			end
			unless(tagsval.nil?)
				hiring  								= 		Hiringauthority.new(:authority => tagsval)
				
				if(hiring.save == true)
					hir 								= 		Hiringauthority.sort(:created_at.desc).all
					hiringid							=		hir[0].id
					employ  							= 		Jobposting.new(:jobid => jobCategory , :jobtype => jobType , :details => details , :postingcompany => postingcompany , :hiringauthority => hiringid, :description => title, :dateopen => opdate, :dateclose => cldate, :numpositions => openings, :salary => salary, :address => address, :city => city, :state => state, :zip => zip, :reviewer => reviewer, :manager => manager, :hrmanager => hrmanager)
					if(employ.save == true)
						@msg     						= 		"successfully inserted"
						redirect_to :action 			=>		"jobPostingNew" , :jobID => employ.id
					end
				end
			end	
		end		
	end
	
	def editJobDetails
		@dataARY      									= 		Array.new
		@hiringAuthority               					= 		Hash.new
		@jobCategory	               					= 		Hash.new
		@hrManager	               						= 		Hash.new
		@manager	               						= 		Hash.new
		@reviewer	               						= 		Hash.new
		
		@jobCategory["Select Job Category"] 			=		""
		@hrManager["Select Job Category"] 				=		""
		@manager["Select Job Category"] 				=		""
		@reviewer["Select Job Category"] 				=		""
		User.where(:employerid => session[:postingcompany]).all.each do |value|
							@hiringAuthority[value.acctname] 				= 		value.id
					  end
		Job.all.each do |val|
							@jobCategory[val.description] 					= 		val.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711c2f1bb55071c001c55").all.each do |val|
							@hrManager[val.acctname] 						= 		val.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711ebf1bb55071c001c56").all.each do |val|
							@manager[val.acctname] 							= 		val.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711fdf1bb55071c001c57").all.each do |val|
							@reviewer[val.acctname] 						= 		val.id
					 end	
		@jobID										=		params[:jobID]				    
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"companyUserList"
        end				    		
		unless(params[:jobID].blank?)
			data									=		Jobposting.find_by_id(params[:jobID].to_s)
			@dataARY.push("jobName" => data.description, "numOfPositions" => data.numpositions, "openDate" => data.dateopen, "close" => data.dateclose, "salary" => data.salary, "address" => data.address, "city" => data.city, "state" => data.state, "zip" => data.zip)
			@userRole								=		data.jobid
		end

	end
	
	def updateJobDetails
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"dashBoard"
        end	
		unless(params[:update].nil?)
			title	 			  					= 		params[:title]
			details	 			  					= 		params[:details]
			openings 			  					= 		params[:openings]
			opdate	 			  					= 		params[:opdate]
			cldate	 			  					= 		params[:cldate]			
			salary	 			  					= 		params[:salary]
			jobCategory			  					= 		params[:jobCategory]
			tagAry  								=  		params[:sel_tagstores]
			
			address 			  					= 		params[:address]
			city	 			  					= 		params[:city]
			state	 			  					= 		params[:state]
			zip		 			  					= 		params[:zip]
			jobType  								=  		params[:type]
			
			hrmanager			  					= 		params[:hrManager]
			manager				  					= 		params[:manager]
			reviewer			  					= 		params[:reviewer]
			unless(tagAry.nil?)
				tagsval  							= 		tagAry.join(',')
			end
			unless(tagsval.nil?)
				hiring  							= 		Hiringauthority.new(:authority => tagsval)
						
				if(hiring.save == true)
					hir 							= 		Hiringauthority.sort(:created_at.desc).all
					hiringid						=		hir[0].id
					employ							=		Jobposting.find_by_id(params[:prospect].to_s)
					unless(employ.nil?)
						employ.description 			= 		title
						employ.details	 			= 		details
						employ.numpositions			= 		openings
						employ.dateopen 			= 		opdate
						employ.dateclose 			= 		cldate
						employ.salary 				= 		salary
						employ.jobid				= 		jobCategory
						employ.address				= 		address
						employ.city					= 		city
						employ.state				= 		state
						employ.zip					= 		zip
						employ.hrmanager			= 		hrmanager
						employ.manager				= 		manager
						employ.reviewer				= 		reviewer
						employ.hiringauthority		= 		hiringid
						employ.jobtype 				= 		jobType
						result  					= 		employ.save
						if(result == true)
							@msg     				=		"successfully inserted"
							redirect_to :action 	=>		"dashBoard"
						end
					end	
				end	
			end
		end	
	end
	

	
	
	def jobPosting
	
		postingcompany									=		session[:postingcompany]
		@hiringAuthority               					= 		Hash.new
		@jobCategory	               					= 		Hash.new
		@jobCategory["Select Job Category"] 			=		""
		User.all.each do |value|
							@hiringAuthority[value.acctname] 				= 		value.id
					  end
		Job.all.each do |val|
							@jobCategory[val.description] 					= 		val.id
					 end			  
						  
		unless(params[:add].nil?)
			title	 			  						= 		params[:title]
			openings 			  						= 		params[:openings]
			opdate	 			  						= 		params[:opdate]
			cldate	 			  						= 		params[:cldate]			
			salary	 			  						= 		params[:salary]
			address 			  						= 		params[:address]
			city	 			  						= 		params[:city]
			state	 			  						= 		params[:state]
			jobCategory			  						= 		params[:jobCategory]
			tagAry  									=  		params[:sel_tagstores]
			unless(tagAry.nil?)
				tagsval  								= 		tagAry.join(',')
			end
			unless(tagsval.nil?)
				hiring  								= 		Hiringauthority.new(:authority => tagsval)
				
				if(hiring.save == true)
					hir 								= 		Hiringauthority.sort(:created_at.desc).all
					hiringid							=		hir[0].id
					employ  							= 		Jobposting.new(:jobid => jobCategory , :postingcompany => postingcompany , :hiringauthority => hiringid, :description => title, :dateopen => opdate, :dateclose => cldate, :numpositions => openings, :salary => salary)
					if(employ.save == true)
						@msg     						= 		"successfully inserted"
						redirect_to :action 			=>		"jobOpening" , :jobID => employ.id
					end
				end
			end	
		end	
	end
	
	def jobPrerequisites
		@skill				               				= 		Hash.new
		@subskill				               			= 		Hash.new
		@thirdSkill				               			= 		Hash.new
		@jobID											=		params[:jobID]
		unless(params[:jobID].nil?)
			@jobName									=		(Jobposting.find_by_id(@jobID)).description	
		end		
		@skill["Select Category"]						=		""
		@subskill["Select Speciality"]					=		""		
		Prequisite.where(:parentid => "0").all.each do |value|
													   @skill[value.name] 				= 		value.id
												   end
		unless(params[:add].nil?)
			jobID										=		params[:jobIDVal]
			unless(jobID.nil?)
				data									=		Jobposting.find_by_id(jobID)
				unless(data.nil?)
					data.status							=		2
					result  							= 		data.save
					if(result == true)
						redirect_to :action 		=>		"dashBoard"
					end	
				end	
			end	
		end
	end
	
	def editPrerequsite
		@prerequsite		               				= 		Hash.new
		@subprerequsite			               			= 		Hash.new
		@thirdprerequsite		               			= 		Hash.new
		@preARY					               			= 		Array.new
		@jobID											=		params[:jobID]
		unless(params[:jobID].nil?)
			@jobName									=		(Jobposting.find_by_id(@jobID)).description	
		end		
		@prerequsite["Select Category"]					=		""
		@subprerequsite["Select Speciality"]			=		""		
		Prequisite.where(:parentid => "0").all.each do |value|
													   @prerequsite[value.name] 				= 		value.id
												   end
		unless(params[:jobID].blank?)
			data										=		(Jobposting.find_by_id(params[:jobID].to_s)).allowedcredentials
			data.each do |vaal|
							prename						=		Prequisite.find_by_id(vaal).name
							@preARY.push("jobName" => prename)
						end
		end										   
	end
	
	def popSecondPre
		@subskill				               		= 		Hash.new
		unless(params[:id].blank?)
			skills	  								=  		params[:id].to_s
			unless(skills.nil?)
				@text	=	Prequisite.where(:parentid => skills).all
			end	
			render :json => @text.map{|c| [c.id, c.name]}
        end	
	end
	
	def PopThirdPre
		@subskill				               		= 		Hash.new
		unless(params[:id].blank?)
			skills	  								=  		params[:id].to_s
			unless(skills.nil?)
				@text	=	Prequisite.where(:parentid => skills).all
			end	
			render :json => @text.map{|c| [c.id, c.name]}
        end	
	end
	
	def addPrequisite
		unless(params[:jobID].blank?)
			data 										= 		params[:jobID]
			preRequisiteARY								=		params[:id]	
			@prename									=		Array.new
			unless(preRequisiteARY.blank?)
				role = (Jobposting.find_by_id(data)).requiredskills
				preRequisiteARY.each do |val|
											unless(role.blank?)
												Jobposting.push({:id => data}, :allowedcredentials => val)
												@prename.push(Prequisite.find_by_id(val))
												
											else
												Jobposting.push({:id => data}, :allowedcredentials => val)
												@prename.push(Prequisite.find_by_id(val))
												
											end
									end
				render :json => @prename.map{|c| [c.id, c.name]}					
			end
		end
	end	
	
	def jobSkills
		@skill				               				= 		Hash.new
		@subskill				               			= 		Hash.new
		@thirdSkill				               			= 		Hash.new
		@jobID											=		params[:jobID]
		unless(params[:jobID].nil?)
			@jobName									=		(Jobposting.find_by_id(@jobID)).description	
		end			
		@skill["Select Category"]						=		""
		@subskill["Select Speciality"]					=		""		
		Skill.where(:parentid => "0").all.each do |value|
												   @skill[value.name] 				= 		value.id
											   end
		unless(params[:add].nil?)
			jobID										=		params[:jobIDVal]
			unless(jobID.nil?)
				data									=		Jobposting.find_by_id(jobID)
				unless(data.nil?)
					data.status							=		3
					result  							= 		data.save
					if(result == true)
						redirect_to :action 		=>			"dashBoard"
					end	
				end	
			end	
		end
	end
	
	
	
	def skillRatingRankVal
		unless(params[:jobID].blank?)
			data 											= 		params[:jobID]
			rankVal											=		params[:rankVal]	
			skill											=		params[:skill]
			unless(session[:userid].nil?)
				checking									=		Skillsrating.find_by_userid_and_jobID(session[:userid].to_s  , data)
				if(checking.nil?)
					skillRate								=		Skillsrating.new(:userid => session[:userid].to_s, :jobID => data)
					if(skillRate.save == true)
						cntins  							= 		Skillrating.new(:skillid => skill, :ranking => rankVal.to_i)
						skillRate.skillrating << cntins
						skillRate.save
					
						if(cntins.save == true)
							Jobposting.push({:id => data}, :skillsrating => skillRate.id)
						    @text								=	"1"
							render :json => @text
						end                
					end
				else
					cnt 										= 		Skillsrating.where('jobID' => data.to_s  , 'skillrating.skillid' => skill.to_s).count
					unless(cnt == 0)	
						skillUpdate								=		checking.skillrating	
						skillUpdate.each do |tag| 
											if(tag.skillid.to_s == skill.to_s)
												tag.ranking			=		rankVal
												result  			= 		checking.save
												if(result == true)
													@text								=	"1"
													render :json => @text
												end
											end	
										end
						
					else
						cntins  								= 		Skillrating.new(:skillid => skill, :ranking => rankVal.to_i)
						checking.skillrating << cntins
						checking.save
					
						if(cntins.save == true)
							@text								=	"1"
							render :json => @text
						end 
					end	                	
				end	
			end
		end
	end
	
	def skillRatingPriorityVal
		unless(params[:jobID].blank?)
			data 											= 		params[:jobID]
			priorityVal										=		params[:priorityVal]	
			skill											=		params[:skill]
			unless(session[:userid].nil?)
				checking									=		Skillsrating.find_by_userid_and_jobID(session[:userid].to_s  , data)
				if(checking.nil?)
					skillRate								=		Skillsrating.new(:userid => session[:userid].to_s, :jobID => data)
					if(skillRate.save == true)
						cntins  							= 		Skillrating.new(:skillid => skill, :priority => priorityVal.to_i)
						skillRate.skillrating << cntins
						skillRate.save
					
						if(cntins.save == true)
							Jobposting.push({:id => data}, :skillsrating => skillRate.id)
						    @text								=	"1"
							render :json => @text
						end                
					end
				else
					cnt 										= 		Skillsrating.where('userid' => session[:userid].to_s  , 'skillrating.skillid' => skill).count
					if(cnt == 0)	
						cntins  								= 		Skillrating.new(:skillid => skill, :priority => priorityVal.to_i)
						checking.skillrating << cntins
						checking.save
					
						if(cntins.save == true)
							@text								=	"1"
							render :json => @text
						end 
					else
						skillUpdate								=		checking.skillrating	
						skillUpdate.each do |tag| 
											if(tag.skillid.to_s == skill.to_s)
												tag.priority		=		priorityVal
												result  			= 		checking.save
												if(result == true)
													@text								=	"1"
													render :json => @text
												end
											end	
										end
					end	                	
				end	
			end
		end
	end
	
	
	def desiredOrRequired
		unless(params[:jobID].blank?)
			data 											= 		params[:jobID]
			value											=		params[:id]	
			skill											=		params[:skill]
			if(value == "0")
				unless(skill.to_s.nil?)
						Jobposting.pull({:id => data}, :requiredskills => skill)
						Jobposting.push({:id => data}, :desiredskills => skill)
						@text								=	"1"
						render :json => @text
				end
			else
				unless(skill.to_s.nil?)
						Jobposting.pull({:id => data}, :desiredskills => skill)
						Jobposting.push({:id => data}, :requiredskills => skill)
						@text								=	"1"
						render :json => @text
				end
			end	
		end
	end
	
	def getSkillID
		@cnt_ary												=		Array.new
		@jobID													=		params[:jobID]
		unless(params[:jobID].nil?)
			data												= 		Jobposting.find_by_id(params[:jobID])	
			reqSkills											=		data.requiredskills
			reqSkills.each do |value|
								@cnt_ary.push(value)	
						   end	
			desSkills											=		data.desiredskills
			desSkills.each do |value|
								@cnt_ary.push(value)		
						   end
			render :json => { 
								:skillID => @cnt_ary 
							}			   	
		end		
	end
	
	def addRequiredSkills
		unless(params[:jobID].blank?)
			data 											= 		params[:jobID]
			skillARY										=		params[:id]	
			@skillName										=		Array.new
			unless(data.to_s.nil?)
				role = (Jobposting.find_by_id(data)).requiredskills
				skillARY.each do |val|
									unless(role.blank?)
										Jobposting.push({:id => data}, :requiredskills => val)
										@skillName.push(Skill.find_by_id(val))
										
									else
										Jobposting.push({:id => data}, :requiredskills => val)
										@skillName.push(Skill.find_by_id(val))
									end
							end
				render :json => @skillName.map{|c| [c.id, c.name]}
			end
		end
	end
	
	def removeRequiredSkills
		flag												=		0
		skillrateID											=		0
		unless(params[:jobID].blank?)
			data 											= 		params[:jobID]
			skill											=		params[:id]	
			unless(skill.to_s.nil?)
				role = (Jobposting.find_by_id(data)).requiredskills
				unless(role.blank?)
					Jobposting.pull({:id => data}, :requiredskills => skill)
					checking								=		Skillsrating.find_by_userid_and_jobID(session[:userid].to_s  , data)
					unless(checking.nil?)
						cnt 								= 		checking.skillrating
						unless(cnt.nil?)
							cnt.each do |val|
										if(val.skillid.to_s == skill.to_s)
											flag					=		1
											skillrateID				=		val.id
										end
									 end	
							if(flag == 1)
								Skillsrating.pull(checking.id , :skillrating => {:skillid => skill})
								render :json => {
												  :skillname => skill
											   }
							else
								render :json => {
												  :skillname => skill
											   }					
							end
						end	
					else
						render :json => {
										  :skillname => skill
									   }					
					end	
				else
					rol = (Jobposting.find_by_id(data)).desiredskills	
					unless(rol.blank?)
						Jobposting.pull({:id => data}, :requiredskills => skill)
						checking								=		Skillsrating.find_by_userid_and_jobID(session[:userid].to_s  , data)
						unless(checking.nil?)
							cnt 								= 		checking.skillrating
							unless(cnt.nil?)
								cnt.each do |val|
											if(val.skillid.to_s == skill.to_s)
												flag					=		1
												skillrateID				=		val.id
											end
										 end	
								if(flag == 1)
									Skillsrating.pull(checking.id , :skillrating => {:skillid => skill})
									render :json => {
													  :skillname => skill
												   }
								else
									render :json => {
													  :skillname => skill
												   }					
								end
							end	
						else
							render :json => {
											  :skillname => skill
										   }					
						end			   
					end
				end	
			end
		end
	end
	
	def companyRegistration
		@compType			               			= 		Hash.new
		Companytype.sort(:name).all.each do |value|
											@compType[value.name] 				= 		value.id
										end
										
		unless(params[:cancel].nil?)
			redirect_to :action 					=>		"employerLogin"
		end								
	
		unless(params[:add].nil?)
			company	 			  					= 		params[:company]
			address 			  					= 		params[:address]
			city	 			  					= 		params[:city]
			state 			  						= 		params[:state]
			zip		 			  					= 		params[:zip]
			comType	  						     	=  		params[:sel_group]
			sector	 			  					= 		params[:opt2]
			
			unless(company.nil?)
				employ								=		Employer.new(:name => company, :address => address, :city => city, :state => state, :zip => zip, :companytype => comType)
				if(employ.save == true)
					@msg     						= 		"successfully inserted"
					session[:companyid]				=		employ.id
					redirect_to :action 			=>		"addUsers"
				end
			end
        end
	end
	
	def editCompany
		@dataARY      								= 		Array.new
		@compType			               			= 		Hash.new
		Companytype.sort(:name).all.each do |value|
											@compType[value.name] 				= 		value.id
										end	
		
		@companyID									=		params[:companyID]				    
		unless(params[:companyID].blank?)
			data									=		Employer.find_by_id(params[:companyID].to_s)
			
			
			@dataARY.push("companyName" => data.name, "address" => data.address, "city" => data.city, "state" => data.state, "zip" => data.zip)
			@companytype							=		data.companytype
		end
	end
	
	def updateCompany
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"dashBoard"
        end	
		unless(params[:update].nil?)
			company	 			  					= 		params[:company]
			address 			  					= 		params[:address]
			city	 			  					= 		params[:city]
			state 			  						= 		params[:state]
			zip		 			  					= 		params[:zip]
			comType	  						     	=  		params[:sel_group]
			unless(company.nil?)
				employ								=		Employer.find_by_id(params[:companyID].to_s)
				unless(employ.nil?)
					employ.name 					= 		company
					employ.address					= 		address
					employ.city 					= 		city
					employ.state 					= 		state
					employ.zip						= 		zip
					employ.companytype				= 		comType

					result  = employ.save
					if(result == true)
						@msg     					= 		"successfully inserted"
						redirect_to :action 		=>		"dashBoard"
					end
				end	
			end
		end	
	end
	
	def addUsers
		unless(session[:companyid].blank?)
			value									=		session[:companyid]
		else
			value									=		session[:postingcompany]
		end	
		@roleArray               					= 		Hash.new
		Userrole.all.each do |value|
								@roleArray[value.rolename] 				= 		value.id
						  end	
		@permissionArray           					= 		Hash.new
		Permission.all.each do |value|
								@permissionArray[value.permission] 		= 		value.id
						    end					  
					  
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"companyUserList"
        end
        
        unless(params[:add].blank?)
			name	 			  					= 		params[:name]
			email	 			  					= 		params[:email]
			roleid	 			  					= 		params[:sel_group]
			permission		  						= 		params[:permission]
			password 			  					= 		params[:password]
			fname			  						= 		params[:fname]
			lname	 			  					= 		params[:lname]
			
			unless(name.nil?)
				employ								=		User.new(:acctname => name, :employerid => value.to_s, :password => password, :email => email, :permission => permission, :roleid => roleid, :firstname => fname, :lastname => lname)
				if(employ.save == true)
					@msg     						= 		"successfully inserted"
					redirect_to :action 			=>		"companyUserList"
				end
			end
        end
	end
	
	def editUser
		@dataARY      								= 		Array.new
		@roleArray               					= 		Hash.new
		Userrole.all.each do |value|
								@roleArray[value.rolename] 				= 		value.id
						  end	
		@permissionArray           					= 		Hash.new
		Permission.all.each do |value|
								@permissionArray[value.permission] 		= 		value.id
						    end	
		@userID										=		params[:prospect]				    
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"companyUserList"
        end				    		
		unless(params[:prospect].blank?)
			data									=		User.find_by_id(params[:prospect].to_s)
			@dataARY.push("accountname" => data.acctname, "email" => data.email, "permission" => data.permission, "roleid" => data.roleid, "firstname" => data.firstname, "lastname" => data.lastname)
			@userRole								=		data.roleid
			@permission								=		data.permission
		end
	end
	
	def updateUser
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"companyUserList"
        end	
		unless(params[:update].nil?)
			email	 			  					= 		params[:email]
			roleid	 			  					= 		params[:sel_group]
			permission		  						= 		params[:permission]
			fname			  						= 		params[:fname]
			lname	 			  					= 		params[:lname]
			unless(fname.nil?)
				employ								=		User.find_by_id(session[:userid].to_s)
				unless(employ.nil?)
					employ.email 					= 		email
					employ.permission				= 		permission
					employ.roleid 					= 		roleid
					employ.firstname 				= 		fname
					employ.lastname					= 		lname

					result  = employ.save
					if(result == true)
						@msg     					= 		"successfully inserted"
						redirect_to :action 		=>		"companyUserList"
					end
				end	
			end
		end	
	end
	
	def companyUserList
		@companyDetails								=		Array.new
		unless(params[:add].blank?)
              redirect_to :action 					=>		"addUsers"
        end
		@cntArray      								= 		Array.new
		@count										=		0
		if(session[:companyid])
			value									=		session[:companyid]
		else
			value									=		session[:postingcompany]
		end	
	
		postingCompanyQry							=		Employer.find_by_id(value.to_s)
		@companyDetails.push("companyName" => postingCompanyQry.name , "companyCity" => postingCompanyQry.city , "companyState" => postingCompanyQry.state, "companyID" => value.to_s)

		@cnt_data  									= 		User.where(:employerid => value.to_s).all
		@cnt_data.each do |val|
		
							role					= 		(Userrole.find_by_id(val.roleid)).rolename
							permission 				=		(Permission.find_by_id(val.permission)).permission
							@cntArray.push("firstname" => val.firstname + ' ' + val.lastname , "email" => val.email , "permission" => permission , "role" => role, "employerid" => val.id)
					   end
					   	
	end
	
	def dashBoard
		unless(params[:add].blank?)
              redirect_to :action 					=>		"jobOpening"
        end
		@count										=		0
		@dash										=		Array.new
		@companyDetails								=		Array.new
		@hiringauthority							=		Array.new
		@cnt_data  									= 		Jobposting.where(:postingcompany => session[:postingcompany]).all
		
		if(session[:companyid])
			value									=		session[:companyid]
		else
			value									=		session[:postingcompany]
		end	
		postingCompanyQry							=		Employer.find_by_id(value.to_s)
		@companyDetails.push("companyName" => postingCompanyQry.name , "companyCity" => postingCompanyQry.city , "companyState" => postingCompanyQry.state, "companyID" => value.to_s)
		unless(@cnt_data.nil?)
				@cnt_data.each do |val|
									   hire				=		val.hiringauthority  
									   stat				=		val.status	
									   @JobSeekerCnt	=		val.jobSeeker
									   if(@JobSeekerCnt.blank?)
											@JobSeekerCount			=		0
									   else
											@JobSeekerCount			=		@JobSeekerCnt.size
									   end	
									   if(stat == 1)
											nextStep	=	"Define Prerequisites"
											action		=	"edit"
											status		=	"Prerequisites Definition"
										elsif(stat == 2)
											nextStep	=	"Define Skills"
											action		=	"edit"	
											status		=	"Skills Definition"
										elsif(stat == 3)
											nextStep	=	"Rank Skills"
											action		=	"rankJob"	
											status		=	"Ranking Job"
										else
											nextStep	=	"Review Applicants"
											action		=	"availableCandidate"	
											status		=	"Review Applicants"	
										end	
									  hire_data			=		Hiringauthority.where(:id => hire)
									  hire_data.each do |valu|
													  hireval			=		valu.authority
													  hirevalues 		= 		hireval.split(',')
													  hirevalues.each do |value|
																			usernmae	=		User.all(:id => value)
																			usernmae.each do |values|
																									
																									@hiringauthority.push(values.firstname + ' ' + values.lastname)
																						  end
																	 end
													 end
									 hiring      				= 		@hiringauthority.join(',')
									 
									 
									 @dash.push("position" => val.description , "owners" => hiring , "jobID" => val.id, "nextStep" => nextStep , "action" => action , "status" => status, "stat" => stat, "noOfDays" => ((Date.today - val.created_at.to_date ).to_i), "noAplied" => @JobSeekerCount)
									 @hiringauthority 			= 				@hiringauthority.clear	
									 unless(@JobSeekerCnt.blank?)
											@JobSeekerCnt				= 				@JobSeekerCnt.clear
									 end	
									 
							end
		end
	end 
	
	def homePage
	end
	
	def edit
		@dataARY      									= 		Array.new
		@hiringAuthority               					= 		Hash.new
		@jobCategory	               					= 		Hash.new
		@hrManager	               						= 		Hash.new
		@manager	               						= 		Hash.new
		@reviewer	               						= 		Hash.new
		@hiringauthor									=		Array.new
		
		@jobCategory["Select Job Category"] 			=		""
		
		@prerequsite		               				= 		Hash.new
		@subprerequsite			               			= 		Hash.new
		@thirdprerequsite		               			= 		Hash.new
		@preARY					               			= 		Array.new
		@jobID											=		params[:jobID]
		unless(params[:jobID].nil?)
			@jobName									=		(Jobposting.find_by_id(@jobID)).description	
		end		
		@prerequsite["Select Category"]					=		""
		@subprerequsite["Select Specialty"]			=		""		
		Prequisite.where(:parentid => "0").all.each do |value|
													   @prerequsite[value.name] 				= 		value.id
												   end
												   
		@skill				               				= 		Hash.new
		@subskill				               			= 		Hash.new
		@thirdSkill				               			= 		Hash.new
		@skill["Select Category"]						=		""
		@subskill["Select Specialty"]					=		""		
		Skill.where(:parentid => "0").all.each do |value|
												   @skill[value.name] 				= 		value.id
											   end
		
		@count											=		0	
		@cnt_ary										=		Array.new
									   
												   
												   
		User.where(:employerid => session[:postingcompany]).all.each do |value|
							@hiringAuthority[value.firstname + ' ' +  value.lastname] 				= 		value.id
					  end
		Job.all.each do |val|
							@jobCategory[val.description] 					= 		val.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711c2f1bb55071c001c55").all.each do |value|
							@hrManager[value.firstname + ' ' +  value.lastname] 						= 		value.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711ebf1bb55071c001c56").all.each do |value|
							@manager[value.firstname + ' ' +  value.lastname] 							= 		value.id
					 end
		User.where(:employerid => session[:postingcompany], :permission => "521711fdf1bb55071c001c57").all.each do |value|
							@reviewer[value.firstname + ' ' +  value.lastname] 						= 		value.id
					 end	
		@jobID										=		params[:jobID]				    
		
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"companyUserList"
        end				    		
		unless(params[:jobID].blank?)
			data									=		Jobposting.find_by_id(params[:jobID].to_s)
			hire									=		data.hiringauthority
			hire_data								=		Hiringauthority.where(:id => hire.to_s)
			hire_data.each do |valu|
							  hireval				=		valu.authority
							  @hirevalues 			= 		hireval.split(',')
							 end
							 
			@HR										=		data.hrmanager
			@man									=		data.manager
			@rev									=		data.reviewer	
			 
			@dataARY.push("jobName" => data.description, "details" => data.details, "numOfPositions" => data.numpositions, "openDate" => data.dateopen, "close" => data.dateclose, "salary" => data.salary, "address" => data.address, "city" => data.city, "state" => data.state, "zip" => data.zip)
			@userRole								=		data.jobid
			
			@jobName								=		data.description	
			preReq									=		data.allowedcredentials
			preReq.each do |vaal|
							prename					=		Prequisite.find_by_id(vaal).name
							@preARY.push("jobName" => prename)
						end
						
			reqSkills												=		data.requiredskills
			unless(reqSkills.blank?)
				reqSkills.each do |value|
									skillQuery						=		Skillsrating.find_by_jobID(params[:jobID].to_s)
									if(skillQuery)
										skillRating						=		skillQuery.skillrating
										skillRating.each do |val| 
															if(val.skillid.to_s == value.to_s)
																@proficency	= val.priority 
																@Impotance	= val.ranking
															end	
														end		
										name							=		Skill.find_by_id(value.to_s).name	
										@cnt_ary.push("skillName" => name, "required" => "YES", "skillID" => value, "skillImp" => @proficency , "skillProf" => @Impotance)	
										@proficency						= 		nil 
										@Impotance						= 		nil
									else
										name							=		Skill.find_by_id(value.to_s).name	
										@cnt_ary.push("skillName" => name, "required" => "YES")
									end	
							   end	
			end				   
			
			desSkills												=		data.desiredskills
			unless(desSkills.blank?)
				desSkills.each do |value|
									skillQuery						=		Skillsrating.find_by_jobID(params[:jobID].to_s)
									skillRating						=		skillQuery.skillrating
									skillRating.each do |val| 
														if(val.skillid.to_s == value.to_s)
															@proficency	= val.priority 
															@Impotance	= val.ranking
														end	
													end		
									name							=		Skill.find_by_id(value.to_s).name
									@cnt_ary.push("skillName" => name, "required" => "NO", "skillID" => value, "skillImp" => @proficency , "skillProf" => @Impotance)		
									@proficency						= 		nil 
									@Impotance						= 		nil
							   end	
			end				   								
		end
	end
	
	def updatePrerequsite
	end
	
	def editJobSkill
		@skill				               				= 		Hash.new
		@subskill				               			= 		Hash.new
		@thirdSkill				               			= 		Hash.new
		@jobID											=		params[:jobID]
		unless(params[:jobID].nil?)
			@jobName									=		(Jobposting.find_by_id(@jobID)).description	
		end			
		@skill["Select Category"]						=		""
		@subskill["Select Speciality"]					=		""		
		Skill.where(:parentid => "0").all.each do |value|
												   @skill[value.name] 				= 		value.id
											   end
		
		@count													=		0	
		@cnt_ary												=		Array.new
		unless(params[:jobID].nil?)
			@jobName											=		(Jobposting.find_by_id(@jobID)).description	
		end			
		unless(params[:jobID].nil?)
			data												= 		Jobposting.find_by_id(params[:jobID])	
			reqSkills											=		data.requiredskills
			reqSkills.each do |value|
								skillQuery						=		Skillsrating.find_by_jobID(params[:jobID].to_s)
								skillRating						=		skillQuery.skillrating
								skillRating.each do |val| 
													if(val.skillid.to_s == value.to_s)
														@proficency	= val.priority 
														@Impotance	= val.ranking
													end	
												end		
								name							=		Skill.find_by_id(value.to_s).name	
								@cnt_ary.push("skillName" => name, "required" => "YES", "skillID" => value, "skillImp" => @proficency , "skillProf" => @Impotance)	
						   end	
			desSkills											=		data.desiredskills
			desSkills.each do |value|
								skillQuery						=		Skillsrating.find_by_jobID(params[:jobID].to_s)
								skillRating						=		skillQuery.skillrating
								skillRating.each do |val| 
													if(val.skillid.to_s == value.to_s)
														@cnt_ary.push("skillImp" => val.priority , "skillProf" => val.ranking)
													end	
												end		
								name							=		Skill.find_by_id(value.to_s).name
								@cnt_ary.push("skillName" => name, "required" => "NO", "skillID" => value, "skillImp" => @proficency , "skillProf" => @Impotance)		
						   end	
		end	
		
	end
	
	def rankJob
		@count													=		0	
		@cnt_ary												=		Array.new
		@jobID													=		params[:jobID]
		unless(params[:jobID].nil?)
			@jobName											=		(Jobposting.find_by_id(@jobID)).description	
		end			
		unless(params[:jobID].nil?)
			data												= 		Jobposting.find_by_id(params[:jobID])	
			reqSkills											=		data.requiredskills
			reqSkills.each do |value|
								skillQuery						=		Skillsrating.find_by_jobID(params[:jobID].to_s)
								skillRating						=		skillQuery.skillrating
								skillRating.each do |val| 
													if(val.skillid.to_s == value.to_s)
														@proficency	= val.priority 
														@Impotance	= val.ranking
													end	
												end		
								name							=		Skill.find_by_id(value.to_s).name	
								@cnt_ary.push("skillName" => name, "required" => "YES", "skillID" => value, "skillImp" => @proficency , "skillProf" => @Impotance)	
						   end	
			desSkills											=		data.desiredskills
			desSkills.each do |value|
								skillQuery						=		Skillsrating.find_by_jobID(params[:jobID].to_s)
								skillRating						=		skillQuery.skillrating
								skillRating.each do |val| 
													if(val.skillid.to_s == value.to_s)
														@proficency	= val.priority 
														@Impotance	= val.ranking
													end	
												end		
								name							=		Skill.find_by_id(value.to_s).name
								@cnt_ary.push("skillName" => name, "required" => "NO", "skillID" => value, "skillImp" => @proficency , "skillProf" => @Impotance)		
						   end	
		end		
	end
	
	def rankJobDone	
		unless(params[:add].nil?)
			jobID										=		params[:jobIDVal]
			unless(jobID.nil?)
				data									=		Jobposting.find_by_id(jobID)
				unless(data.nil?)
					data.status							=		4
					result  							= 		data.save
					if(result == true)
						redirect_to :action 			=>		"dashBoard"
					end	
				end	
			end	
		end
	end
	
	def postPosition 
	end
	
	def popupPostPosition
		@jobID											=		params[:jobID]
	end
	
	def addPostPosition
		unless(params[:jobIDVal].nil?)
			jobID										=		params[:jobIDVal]
			closedate	 			  					= 		params[:cldate]
			unless(jobID.nil?)
				data									=		Jobposting.find_by_id(jobID)
				unless(data.nil?)
					data.status							=		5
					data.dateclose						=		closedate
					result  							= 		data.save
					if(result == true)
						@text					=	"1"
						render :json => @text
					end	
				end	
			end	
		end
	end	
	
	def availableCandidate
		
		@candidateName									= 		Array.new
		@count											=		0
		@i												=		0
		@candidateCnt									=		1
		@cnt_ary										=		Array.new
		@jobID											=		params[:jobID]
		@jobsekerAry									=		Array.new
		@skillData										=		Array.new

		keywordsPortfolioitemskill						=		Array.new	
		keywordsPortfolioitems							=		Array.new	
		keywordsPortfolio								=		Array.new	
		keywordsUser									=		Array.new
		@rate											=		Array.new	
		
		keywordsId										=		Array.new
		@portSkill										=		Array.new
		
		@available										=		Array.new
		
		@totalSkillScore								=		0
		@totalEmployeeScore								=		0
		
		unless(params[:search].nil?)
			@cnt_ary									= 		@cnt_ary.clear
			Portfolio.all.each do |value|
									userid = value.id
									Portfolioitem.where(:portfolioid =>userid.to_s).all.each do |valu|
																								portId	=	valu.id
																								@portSkill.push((Portfolioitemskill.find_by_portfolioitemid(portId.to_s)).skillid)
																								@portSkill							   = 		@portSkill.uniq																 	
																							end
									
									if((params[:skill] - @portSkill).empty?)
										keywordsUser.push(value.ownerid)
									end
									@portSkill			= 		@portSkill.clear
								end	
									
									
			
			keywordsUser								= 		keywordsUser.uniq							
			keywordsUser.each do |val|
									jobsApply			=		Prospect.find_by_id(val).jobsapplied
									noOfJobs			=		jobsApply.length			
									@cnt_ary.push("candidateName" => 'Candidate'  + ' ' + @candidateCnt.to_s, "appliedFor" => noOfJobs, "candidateID" => val)
									@candidateCnt		=		@candidateCnt + 1	
								end	
								
		end	
		

		
		unless(params[:jobID].blank?)
			@cnt_ary						= 				@cnt_ary.clear
			info							=				Jobposting.find_by_id(params[:jobID])
			data							=				info.jobSeeker
			reqSkills						=				info.requiredskills
			desSkills						=				info.desiredskills
			unless(data.blank?)
				data.each do |val|
								@jobsekerAry.push(val.to_s)
								
								
								userid 		= 		Portfolio.find_by_ownerid(val.to_s).id
								Portfolioitem.where(:portfolioid => userid.to_s).all.each do |valu|
													portId				=		valu.id
													skillQuery			=		Portfolioitemskill.find_by_portfolioitemid(portId.to_s)
													unless(skillQuery.value.blank?)	
														@skillData.push("skillID" => skillQuery.skillid, "value" => skillQuery.value) 
													end
											   end	
								unless(reqSkills.blank?)
									reqSkills.each do |value|
														skillQuery						=		Skillsrating.find_by_jobID(params[:jobID].to_s)
														skillRating						=		skillQuery.skillrating
														skillRating.each do |val| 
																			if(val.skillid.to_s == value.to_s)
																				@proficency	= val.priority.to_i 
																				@Impotance	= val.ranking.to_i 
																			end	
																		end		
															
														
														if(@skillData.empty?)
															@rate.push("jobseekerID" => val ,"skillID" => value, "prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)																	
														else
															if(h = @skillData.find { |h| h['skillID'] == value })
																h['value'].each do |vlue|
																						@prof				=		vlue.proficency.to_i
																						@rate.push("jobseekerID" => val , "skillID" => value, "prof" => @prof, "employerProf" => @proficency , "employerImp" => @Impotance)
																				  end	
															else
																 @rate.push("jobseekerID" => val , "skillID" => value, "prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)
															end	
														end	
														@proficency	=	nil
														@Impotance	=	nil
												   end	
								end	
								unless(desSkills.blank?)			   
									 desSkills.each do |value|
														skillQuery						=		Skillsrating.find_by_jobID(params[:jobID].to_s)
														skillRating						=		skillQuery.skillrating
														skillRating.each do |val| 
																			if(val.skillid.to_s == value.to_s)
																				@proficency	= val.priority.to_i 
																				@Impotance	= val.ranking.to_i 
																			end	
																		end		
															
														
														if(@skillData.empty?)
															@rate.push("prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)																	
														else
															if(h = @skillData.find { |h| h['skillID'] == value })
																h['value'].each do |vlue|
																						@prof				=		vlue.proficency.to_i
																						@rate.push("prof" => @prof, "employerProf" => @proficency , "employerImp" => @Impotance)
																				  end	
															else
																 @rate.push("prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)
															end	
														end	
														@proficency	=	nil
														@Impotance	=	nil
												   end	
								end	
								
								@rate.each do |value|
												if((value['prof'].to_i == 1) && (value['employerProf'].to_i == 1))
													@gaf		=	1
												elsif((value['prof'].to_i == 1) && (value['employerProf'].to_i == 2))	
													@gaf		=	1.05
												elsif((value['prof'].to_i == 1) && (value['employerProf'].to_i == 3))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 1) && (value['employerProf'].to_i == 4))
													@gaf		=	1.15
												elsif((value['prof'].to_i == 1) && (value['employerProf'].to_i == 5))
													@gaf		=	1.2
												elsif((value['prof'].to_i == 2) && (value['employerProf'].to_i == 1))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 2) && (value['employerProf'].to_i == 2))
													@gaf		=	1
												elsif((value['prof'].to_i == 2) && (value['employerProf'].to_i == 3))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 2) && (value['employerProf'].to_i == 4))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 2) && (value['employerProf'].to_i == 5))
													@gaf		=	1.15
												elsif((value['prof'].to_i == 3) && (value['employerProf'].to_i == 1))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 3) && (value['employerProf'].to_i == 2))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 3) && (value['employerProf'].to_i == 3))
													@gaf		=	1
												elsif((value['prof'].to_i == 3) && (value['employerProf'].to_i == 4))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 3) && (value['employerProf'].to_i == 5))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 4) && (value['employerProf'].to_i == 1))
													@gaf		=	1.15
												elsif((value['prof'].to_i == 4) && (value['employerProf'].to_i == 2))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 4) && (value['employerProf'].to_i == 3))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 4) && (value['employerProf'].to_i == 4))
													@gaf		=	1
												elsif((value['prof'].to_i == 4) && (value['employerProf'].to_i == 5))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 5) && (value['employerProf'].to_i == 1))
													@gaf		=	1.2
												elsif((value['prof'].to_i == 5) && (value['employerProf'].to_i == 2))
													@gaf		=	1.15
												elsif((value['prof'].to_i == 5) && (value['employerProf'].to_i == 3))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 5) && (value['employerProf'].to_i == 4))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 5) && (value['employerProf'].to_i == 5))
													@gaf		=	1
												else
													@gaf		=	1	
												end	
												if(value['prof'].to_i >0)
													absl	= (value['prof'].to_i - value['employerProf'].to_i).abs
													@totalEmployeeScore	=	@totalEmployeeScore + (((value['employerProf'].to_i - absl)*value['employerImp'].to_i)/@gaf)
													@totalSkillScore	=	@totalSkillScore	 + (value['employerProf'].to_i * value['employerImp'].to_i)
												else
													@totalEmployeeScore	=	@totalEmployeeScore + 0
													@totalSkillScore	=	@totalSkillScore	 + (value['employerProf'].to_i * value['employerImp'].to_i)
												end	
										   end												   			   
								
									
								jobApplied					=		Prospect.find_by_id(val.to_s).jobsapplied
								if(jobApplied)
									@count					=		jobApplied.length
								else
									@count					=		0		
								end	
								if(@totalSkillScore.to_f > 100)
									normal					=		@totalSkillScore.to_f/100
									@totalSkillScore		=		@totalSkillScore.to_f/normal.to_f
									@totalEmployeeScore		=		@totalEmployeeScore.to_f/normal.to_f
								else
									normal					=		100/@totalSkillScore.to_f
									@totalSkillScore		=		@totalSkillScore.to_f*normal.to_f
									@totalEmployeeScore		=		@totalEmployeeScore.to_f*normal.to_f	
								end					
								@cnt_ary.push("candidateName" => 'Candidate' + ' ' +  @candidateCnt.to_s, "appliedFor" => @count, "candidateID" => val, "check" => 0 , "jobSkillScore" => @totalSkillScore.to_i  , "employeeSkillScore" => @totalEmployeeScore.to_i)
								
								@count						=				0
								@totalSkillScore			=				0
								@totalEmployeeScore			=				0
								jobApplied					=				nil	
								@rate.clear	
								@skillData.clear
								@candidateCnt				=		@candidateCnt + 1
						  end
			end
			dat													= 		Jobposting.find_by_id(params[:jobID])	
			reqSkills											=		dat.requiredskills
			Portfolio.all.each do |value|
									userid = value.id
									Portfolioitem.where(:portfolioid =>userid.to_s).all.each do |valu|
																								portId	=	valu.id
																								@portSkill.push((Portfolioitemskill.find_by_portfolioitemid(portId.to_s)).skillid)
																								@portSkill							   = 		@portSkill.uniq																 	
																							end
									
									if((reqSkills - @portSkill).empty?)
										keywordsUser.push(value.ownerid)
										unless(@jobsekerAry.blank?)
											keywordsUser			=				keywordsUser - @jobsekerAry
										end
									end
									@portSkill						= 				@portSkill.clear
								end	

			unless(keywordsUser.blank?)
				keywordsUser.each do |val|
								
								
								userid 		= 		Portfolio.find_by_ownerid(val.to_s).id
								Portfolioitem.where(:portfolioid => userid.to_s).all.each do |valu|
													portId				=		valu.id
													skillQuery			=		Portfolioitemskill.find_by_portfolioitemid(portId.to_s)
													unless(skillQuery.value.blank?)	
														@skillData.push("skillID" => skillQuery.skillid, "value" => skillQuery.value) 
													end
											   end	
								unless(reqSkills.blank?)
									reqSkills.each do |value|
														skillQuery						=		Skillsrating.find_by_jobID(params[:jobID].to_s)
														skillRating						=		skillQuery.skillrating
														skillRating.each do |val| 
																			if(val.skillid.to_s == value.to_s)
																				@proficency	= val.priority.to_i 
																				@Impotance	= val.ranking.to_i 
																			end	
																		end		
															
														
														if(@skillData.empty?)
															@rate.push("jobseekerID" => val ,"skillID" => value, "prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)																	
														else
															if(h = @skillData.find { |h| h['skillID'] == value })
																h['value'].each do |vlue|
																						@prof				=		vlue.proficency.to_i
																						@rate.push("jobseekerID" => val , "skillID" => value, "prof" => @prof, "employerProf" => @proficency , "employerImp" => @Impotance)
																				  end	
															else
																 @rate.push("jobseekerID" => val , "skillID" => value, "prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)
															end	
														end	
														@proficency	=	nil
														@Impotance	=	nil
												   end	
								end	
								unless(reqSkills.blank?)			   
									 desSkills.each do |value|
														skillQuery						=		Skillsrating.find_by_jobID(params[:jobID].to_s)
														skillRating						=		skillQuery.skillrating
														skillRating.each do |val| 
																			if(val.skillid.to_s == value.to_s)
																				@proficency	= val.priority.to_i 
																				@Impotance	= val.ranking.to_i 
																			end	
																		end		
															
														
														if(@skillData.empty?)
															@rate.push("prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)																	
														else
															if(h = @skillData.find { |h| h['skillID'] == value })
																h['value'].each do |vlue|
																						@prof				=		vlue.proficency.to_i
																						@rate.push("prof" => @prof, "employerProf" => @proficency , "employerImp" => @Impotance)
																				  end	
															else
																 @rate.push("prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)
															end	
														end	
														@proficency	=	nil
														@Impotance	=	nil
												   end	
								end				   			   
								
								@rate.each do |value|
												if((value['prof'].to_i == 1) && (value['employerProf'].to_i == 1))
													@gaf		=	1
												elsif((value['prof'].to_i == 1) && (value['employerProf'].to_i == 2))	
													@gaf		=	1.05
												elsif((value['prof'].to_i == 1) && (value['employerProf'].to_i == 3))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 1) && (value['employerProf'].to_i == 4))
													@gaf		=	1.15
												elsif((value['prof'].to_i == 1) && (value['employerProf'].to_i == 5))
													@gaf		=	1.2
												elsif((value['prof'].to_i == 2) && (value['employerProf'].to_i == 1))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 2) && (value['employerProf'].to_i == 2))
													@gaf		=	1
												elsif((value['prof'].to_i == 2) && (value['employerProf'].to_i == 3))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 2) && (value['employerProf'].to_i == 4))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 2) && (value['employerProf'].to_i == 5))
													@gaf		=	1.15
												elsif((value['prof'].to_i == 3) && (value['employerProf'].to_i == 1))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 3) && (value['employerProf'].to_i == 2))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 3) && (value['employerProf'].to_i == 3))
													@gaf		=	1
												elsif((value['prof'].to_i == 3) && (value['employerProf'].to_i == 4))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 3) && (value['employerProf'].to_i == 5))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 4) && (value['employerProf'].to_i == 1))
													@gaf		=	1.15
												elsif((value['prof'].to_i == 4) && (value['employerProf'].to_i == 2))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 4) && (value['employerProf'].to_i == 3))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 4) && (value['employerProf'].to_i == 4))
													@gaf		=	1
												elsif((value['prof'].to_i == 4) && (value['employerProf'].to_i == 5))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 5) && (value['employerProf'].to_i == 1))
													@gaf		=	1.2
												elsif((value['prof'].to_i == 5) && (value['employerProf'].to_i == 2))
													@gaf		=	1.15
												elsif((value['prof'].to_i == 5) && (value['employerProf'].to_i == 3))
													@gaf		=	1.1
												elsif((value['prof'].to_i == 5) && (value['employerProf'].to_i == 4))
													@gaf		=	1.05
												elsif((value['prof'].to_i == 5) && (value['employerProf'].to_i == 5))
													@gaf		=	1
												else
													@gaf		=	1	
												end	
												if(value['prof'].to_i >0)
													absl	= (value['prof'].to_i - value['employerProf'].to_i).abs
													@totalEmployeeScore	=	@totalEmployeeScore + (((value['employerProf'].to_i - absl)*value['employerImp'].to_i)/@gaf)
													@totalSkillScore	=	@totalSkillScore	 + (value['employerProf'].to_i * value['employerImp'].to_i)
												else
													@totalEmployeeScore	=	@totalEmployeeScore + 0
													@totalSkillScore	=	@totalSkillScore	 + (value['employerProf'].to_i * value['employerImp'].to_i)
												end	
										   end	
								jobApplied					=		Prospect.find_by_id(val.to_s).jobsapplied
								if(jobApplied)
									@count					=		jobApplied.length
								else
									@count					=		0		
								end	
								if(@totalSkillScore > 100)
									normal					=		@totalSkillScore.to_f/100
									@totalSkillScore		=		@totalSkillScore.to_f/normal.to_f
									@totalEmployeeScore		=		@totalEmployeeScore.to_f/normal.to_f
								else
									normal					=		100/@totalSkillScore.to_f
									@totalSkillScore		=		@totalSkillScore.to_f*normal.to_f
									@totalEmployeeScore		=		@totalEmployeeScore.to_f*normal.to_f	
								end						   	
								@cnt_ary.push("candidateName" => 'Candidate' + ' ' +  @candidateCnt.to_s, "appliedFor" => @count, "candidateID" => val, "check" => 1 , "jobSkillScore" => @totalSkillScore.to_i  , "employeeSkillScore" => @totalEmployeeScore.to_i)
								
								@count						=				0
								@totalSkillScore			=				0
								@totalEmployeeScore			=				0
								jobApplied					=				nil									
								@rate.clear	
								@skillData.clear
								@candidateCnt		=		@candidateCnt + 1							
						  end
				 unless(@cnt_ary.blank?)
					@cnt_ary.sort_by! {|e| -e["employeeSkillScore"] }
				 end			  
			end
		end	
			
		
		
		unless(params[:add].nil?)
			redirect_to :action 		=>		"candidateComparison"
		end
	end
	
	def jobSeekerContact
		@cnt_ary						=		Array.new
		unless(params[:prospect].nil?)
			jobSeekerDetails				=		Prospect.find_by_id(params[:prospect].to_s)
			@cnt_ary.push("candidateName" => jobSeekerDetails.employeefirstname , "candidateLName" => jobSeekerDetails.employeelastname , "candidateAddress" => jobSeekerDetails.employeeaddress , "candidateEmail" => jobSeekerDetails.employeeemail)
		end
	end
	
	def jobSeekerProfile
		@count							=		0		
		portSkill						=		Array.new
		@cnt_ary						=		Array.new	
		@skillDetails					=		Array.new	
		@workHistory					=		Array.new	
		@education						=		Array.new
		@jobseekerID					=		Array.new
		@jobseekerID.push("id" => params[:prospect])
		@jobseekerIDVal					=		 params[:prospect]
		@jobID							=		 params[:jobID]
		unless(params[:prospect].nil?)
			information						=		Portfolio.find_by_ownerid(params[:prospect].to_s)
			unless(information.nil?)
				id							=		information.id
				workHistory					=		information.workhistory	
				education					=		information.education	
			end		
			unless(workHistory.nil?)       
					workHistory.each do |val|
											@workHistory.push("title" => val.title , "company" => val.company , "fromdate" => val.fromdate , "tilldate" => val.tilldate)
									 end
				
			end	
			unless(education.nil?)       
					education.each do |val|
											@education.push("degree" => val.degree , "college" => val.college, "field" => val.field , "date" => val.date)
									 end
				
			end	
			unless(id.nil?)
				Portfolioitem.where(:portfolioid =>id.to_s).all.each do |valu|
						portId				=		valu.id
						skill				=		Portfolioitemskill.find_by_portfolioitemid(portId.to_s)
						skillID				=		skill.skillid
						skillInfo			=		Skill.find_by_id(skillID.to_s)
						skillName			=		skillInfo.name
						skillParent			=		skillInfo.parentid
						
						specialityInfo		=		Skill.find_by_id(skillParent.to_s)
						specialityName		=		specialityInfo.name
						speciality			=		specialityInfo.parentid
						
						categoryInfo		=		Skill.find_by_id(speciality.to_s)
						categoryName		=		categoryInfo.name
						
						info				=		skill.value	
						unless(info.blank?)
								info.each do |vale|
												unless(vale.proficency.nil?)
													@prof	=	vale.proficency
												else
													@prof	=	5
												end	
										  end
							else
									@prof	=	5		
							end	
										@skillDetails.push("categoryName" => categoryName, "specialityName" => specialityName, "skillName" => skillName , "skillProficency" => @prof)
							  
					end
			end	
		end
	end
	
	def connectCandidate
		unless(params[:jobID].blank?)
			data 											= 		params[:jobID]
			candidateID										=		params[:id]	
			unless(candidateID.to_s.nil?)
				role 										= 		(Prospect.find_by_id(candidateID)).invited
				unless(role.blank?)
					Prospect.push({:id => candidateID}, :invited => data)
					@text								=	"1"
					render :json => @text
								   
				else
					Prospect.push({:id => candidateID}, :invited => data)
					@text								=	"1"
					render :json => @text
				end
			end
		end
	end 
	
	def candidateComparison 
		@Req_skill													=		Array.new
		@Des_skill													=		Array.new
		@skillData													=		Array.new
		@candidateData												=		Array.new
		@candidateCnt												=		1

		unless(params[:add].nil?)
			@jobID													=		params[:jobIDVal]						
			@candidateAry											=		params[:candidate]
			unless(@jobID.blank?)
				data												= 		Jobposting.find_by_id(@jobID)	
				reqSkills											=		data.requiredskills
				desSkills											=		data.desiredskills
				@count												=		@candidateAry.size
				@countSkill											=		reqSkills.size
				@countDesSkill										=		desSkills.size
				@candidateAry.each do |val|
										name						=		Prospect.find_by_id(val)	
										@candidateData.push("candidateFirstName" => 'Candidate' + ' ' + @candidateCnt.to_s, "candidateID" => val)
										@candidateCnt				=		@candidateCnt + 1
										userid 						= 		Portfolio.find_by_ownerid(val.to_s).id
										unless(userid.nil?)
											Portfolioitem.where(:portfolioid => userid.to_s).all.each do |valu|
																											portId				=		valu.id
																											skillQuery			=		Portfolioitemskill.find_by_portfolioitemid(portId.to_s)
																											unless(skillQuery.value.blank?)	
																												@skillData.push("skillID" => skillQuery.skillid, "value" => skillQuery.value) 
																											end
																									   end		
											reqSkills.each do |value|
																skillQuery						=		Skillsrating.find_by_jobID(@jobID.to_s)
																skillRating						=		skillQuery.skillrating
																skillRating.each do |val| 
																					if(val.skillid.to_s == value.to_s)
																						@proficency	= val.priority.to_i 
																					end	
																				end	
																if(@skillData.empty?)
																	@name											=		Skill.find_by_id(value).name
																	@Req_skill.push("skillName" => @name, "prof" => 0, "empprof" => @proficency)																	
																else
																	if(h = @skillData.find { |h| h['skillID'] == value })
																		h['value'].each do |vlue|
																								@prof				=		vlue.proficency
																								@name				=		Skill.find_by_id(value).name	
																								@Req_skill.push("skillName" => @name, "prof" => @prof, "empprof" => @proficency)
																						  end	
																	else
																		 @name											=		Skill.find_by_id(value).name
																		 @Req_skill.push("skillName" => @name, "prof" => 0, "empprof" => @proficency)
																	end	
																end
																@proficency	=	nil	
															end	
															
											desSkills.each do |value|
																skillQuery						=		Skillsrating.find_by_jobID(@jobID.to_s)
																skillRating						=		skillQuery.skillrating
																skillRating.each do |val| 
																					if(val.skillid.to_s == value.to_s)
																						@proficency	= val.priority.to_i 
																					end	
																				end	
																if(@skillData.empty?)
																	@name											=		Skill.find_by_id(value).name
																	@Des_skill.push("skillName" => @name, "prof" => 0, "empprof" => @proficency)																	
																else
																	if(h = @skillData.find { |h| h['skillID'] == value })
																		h['value'].each do |vlue|
																								@prof				=		vlue.proficency
																								@name				=		Skill.find_by_id(value).name	
																								@Des_skill.push("skillName" => @name, "prof" => @prof, "empprof" => @proficency)
																						  end	
																	else
																		 @name											=		Skill.find_by_id(value).name
																		 @Des_skill.push("skillName" => @name, "prof" => 0, "empprof" => @proficency)
																	end	
																end	
																@proficency	=	nil
															end						
											@skillData										=		@skillData.clear														  
										end	
								   end

			else
				@msg     						= 		"Cndidate comparision is presently not allowed for search candidate"
			end

		end	
	end
	
	def candidateEvaluation
		unless(params[:add].nil?)
			redirect_to :action 		=>		"dashBoard"
		end
		
		@Req_skill													=		Array.new
		@Des_skill													=		Array.new
		@skillData													=		Array.new		
		@jobID														=		params[:jobID]	
		@jobSeekerID											    =		params[:jobseekerIDVal] 
		@count														=		0
		unless(@jobID.blank?)
			data													= 		Jobposting.find_by_id(@jobID)	
			reqSkills												=		data.requiredskills
			desSkills												=		data.desiredskills
			userid 													= 		Portfolio.find_by_ownerid(@jobSeekerID.to_s).id
			unless(userid.nil?)
				Portfolioitem.where(:portfolioid => userid.to_s).all.each do |valu|
																				portId				=		valu.id
																				skillQuery			=		Portfolioitemskill.find_by_portfolioitemid(portId.to_s)
																				unless(skillQuery.value.blank?)	
																					@skillData.push("skillID" => skillQuery.skillid, "value" => skillQuery.value) 
																				end
																		   end		
				reqSkills.each do |value|
									skillQuery						=		Skillsrating.find_by_jobID(@jobID.to_s)
									skillRating						=		skillQuery.skillrating
									skillRating.each do |val| 
														if(val.skillid.to_s == value.to_s)
															@proficency	= val.priority.to_i 
														end	
													end	
									if(@skillData.empty?)
										@name											=		Skill.find_by_id(value).name
										@Req_skill.push("skillName" => @name, "prof" => 0, "empprof" => @proficency)																	
									else
										if(h = @skillData.find { |h| h['skillID'] == value })
											h['value'].each do |vlue|
																	@prof				=		vlue.proficency
																	@name				=		Skill.find_by_id(value).name	
																	@Req_skill.push("skillName" => @name, "prof" => @prof, "empprof" => @proficency)
															  end	
										else
											 @name											=		Skill.find_by_id(value).name
											 @Req_skill.push("skillName" => @name, "prof" => 0, "empprof" => @proficency)
										end	
									end
									@proficency	=	nil	
								end	
								
				desSkills.each do |value|
									skillQuery						=		Skillsrating.find_by_jobID(@jobID.to_s)
									skillRating						=		skillQuery.skillrating
									skillRating.each do |val| 
														if(val.skillid.to_s == value.to_s)
															@proficency	= val.priority.to_i 
														end	
													end	
									if(@skillData.empty?)
										@name											=		Skill.find_by_id(value).name
										@Des_skill.push("skillName" => @name, "prof" => 0, "empprof" => @proficency)																	
									else
										if(h = @skillData.find { |h| h['skillID'] == value })
											h['value'].each do |vlue|
																	@prof				=		vlue.proficency
																	@name				=		Skill.find_by_id(value).name	
																	@Des_skill.push("skillName" => @name, "prof" => @prof, "empprof" => @proficency)
															  end	
										else
											 @name											=		Skill.find_by_id(value).name
											 @Des_skill.push("skillName" => @name, "prof" => 0, "empprof" => @proficency)
										end	
									end	
									@proficency	=	nil
								end						
				@skillData										=		@skillData.clear														  
			end	
		end					
	end 
	
	def candidateSelection
		unless(params[:add].nil?)
			redirect_to :action 		=>		"dashBoard"
		end
	end 
	
	def portfolio
		unless(params[:add].nil?)
			@hiringAuthority               			= 		Hash.new
			User.all.each do |value|
								@hiringAuthority[value.acctname] 				= 		value.id
						  end     
		end
	end
	
	def systemJob
	end
	
	def login
		unless(params[:login].nil?)
			empUsName								=		params[:empUsName]
			empPass							    	=		params[:empPass]
			
			unless(empUsName.nil?)
				emp_data  							= 		User.find_by_acctname(empUsName)
				unless(emp_data.nil?)
					password						=		emp_data.password
					unless(password.nil?)
						if(empPass == password)
							session[:empfirst]		=		emp_data.firstname
							session[:emplast]		=		emp_data.lastname
							session[:postingcompany]=		emp_data.employerid
							session[:userid]		=		emp_data.id
							redirect_to :action 	=>		"dashBoard"
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
	
	def employerLogin
		unless(params[:login].nil?)
			empUsName								=		params[:empUsName]
			empPass							    	=		params[:empPass]
			
			unless(empUsName.nil?)
				emp_data  							= 		User.find_by_acctname(empUsName)
				unless(emp_data.nil?)
					password						=		emp_data.password
					unless(password.nil?)
						if(empPass == password)
							session[:empfirst]		=		emp_data.firstname
							session[:emplast]		=		emp_data.lastname
							session[:postingcompany]=		emp_data.employerid
							session[:userid]		=		emp_data.id
							redirect_to :action 	=>		"dashBoard"
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
		
		
		unless(params[:logins].nil?)
			empUsName								=		params[:empUsNames]
			empPass							    	=		params[:empPasss]
			unless(empUsName.nil?)
				emp_data  							= 		Prospect.find_by_employeeusername(empUsName)
				unless(emp_data.nil?)
					password						=		emp_data.employeepassword
					unless(password.nil?)
						if(empPass == password)
							session[:userid]		=		emp_data.id
							session[:name]			=		emp_data.employeefirstname
							session[:lastname]		=		emp_data.employeelastname
							redirect_to :controller => 'employee', :action => 'dashboard'						
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
							redirect_to :controller => 'educator', :action => 'courseList'
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
	
	def signout
		session[:empfirst]		=		nil
		session[:emplast]		=		nil
		session[:postingcompany]=		nil
		session[:userid]		=		nil
		
		session[:username]		=		nil
		session[:userid]		=		nil
		session[:name]			=		nil
		session[:lastname]		=		nil
		
		redirect_to :action 	=>		"homePage"
	end
	
	def selectionPage
	end
	
	def candidateSearch
		keywordsPortfolioitemskill						=		Array.new	
		keywordsPortfolioitems							=		Array.new	
		keywordsPortfolio								=		Array.new	
		keywordsUser									=		Array.new	
		@skill				               				= 		Hash.new
		@jobs				               				= 		Hash.new
		@subskill				               			= 		Hash.new
		@thirdSkill				               			= 		Hash.new
		@skill["Select Category"]						=		""
		@subskill["Select Specialty"]					=		""		
		Skill.where(:parentid => "0").all.each do |value|
												   @skill[value.name] 				= 		value.id
											   end
		
		@jobs["Select a job"]							=		""									   
		Jobposting.where(:postingcompany => session[:postingcompany]).all.each do |value|
												   @jobs[value.description] 				= 		value.id
											   end									   
											   
		unless(params[:search].nil?)
			params[:skill].each do |val|
									Portfolioitemskill.where(:skillid => val.to_s).all.each do |vale|
																								  keywordsPortfolioitemskill.push(vale.portfolioitemid)
																							  end	
								end	
			keywordsPortfolioitemskill.each do |val|
												keywordsPortfolioitems.push((Portfolioitem.find_by_id(val.to_s)).portfolioid)
											end	
			keywordsPortfolioitems.each do |val|
											keywordsPortfolio.push((Portfolio.find_by_id(val.to_s)).ownerid)
										end	
			keywordsPortfolio.each do |val|
										keywordsUser.push((Prospect.find_by_id(val.to_s)).employeeusername)
									end	
			keywordsUser							   = 		keywordsUser.uniq
			render :text => keywordsUser
		end									   
	end
	
	def employeeSearch
		keywordsId										=		Array.new
		keywordsPortfolioitemskill						=		Array.new	
		keywordsPortfolioitems							=		Array.new	
		keywordsPortfolio								=		Array.new	
		keywordsUser									=		Array.new	
		
		keywordsId										=		Array.new
		users											=		Array.new	
		portID											=		Array.new
		portSkill										=		Array.new
		unless(params[:search].nil?)
		
			keywords									=		params[:title].split(/ /)
			if(keywords.include?("and"))
				keywords.delete("and")
				concept = "and"
			elsif(keywords.include?("AND"))
				keywords.delete("AND")
				concept = "and"	
			elsif(keywords.include?("OR"))
				keywords.delete("or")
				concept = "or"	
			else	
				keywords.delete("or")
				concept = "or"	
			end	
			keywords.each do |val|
							   keywordsId.push((Skill.find_by_name(val)).id.to_s)
						  end
			
			if(concept == "and")
				Portfolio.all.each do |value|
										userid = value.id
										Portfolioitem.where(:portfolioid =>userid.to_s).all.each do |valu|
																									portId	=	valu.id
																									portSkill.push((Portfolioitemskill.find_by_portfolioitemid(portId.to_s)).skillid)
																									portSkill							   = 		portSkill.uniq																 	
																								end
										
										if((keywordsId - portSkill).empty?)
											keywordsUser.push((Prospect.find_by_id(value.ownerid)).employeeusername)
										end
										portSkill					= 				portSkill.clear
									end	
									render :text =>	keywordsUser
			else
				keywordsId.each do |val|
								Portfolioitemskill.where(:skillid => val.to_s).all.each do |vale|
																							  keywordsPortfolioitemskill.push(vale.portfolioitemid)
																						  end	
						    end	
				keywordsPortfolioitemskill.each do |val|
													keywordsPortfolioitems.push((Portfolioitem.find_by_id(val.to_s)).portfolioid)
												end	
				keywordsPortfolioitems.each do |val|
												keywordsPortfolio.push((Portfolio.find_by_id(val.to_s)).ownerid)
											end	
				keywordsPortfolio.each do |val|
											keywordsUser.push((Prospect.find_by_id(val.to_s)).employeeusername)
										end	
				keywordsUser							   = 		keywordsUser.uniq							
				render :text =>	keywordsUser		
			end						

																													    			   
		end	
	end
	
	def listInstitution
		unless(params[:AddInstitution].blank?)
              redirect_to :action 					=>		"addInstitution"
        end
        
        unless(params[:AddCourse].blank?)
              redirect_to :action 					=>		"addCourse"
        end
        
        @count										=		0
		@cntArray      								= 		Array.new
		@totalcnt  									= 		Institution.all.count
		cnt_data  									= 		Institution.sort(:name).all
		 unless(cnt_data.nil?)
			cnt_data.each do |val|
								@cntArray.push(val.name)
						 end
	     end	
	end  
	   
	def addInstitution
		unless(params[:cancel].nil?)
			redirect_to :action 				   =>		"listInstitution"
		end
		
		unless(params[:add].nil?)
			name	 			  					= 		params[:insName]
			location								=		params[:location]
			website	 			  					= 		params[:insWebsite]
			
			unless(name.nil?)
				institution							=		Institution.new(:name => name, :location => location, :website => website)
				if(institution.save == true)
					@msg     						= 		"successfully inserted"
					redirect_to :action 			=>		"listInstitution"
				end
			end
        end
	end
	
	def addCourse
		unless(params[:cancel].nil?)
			redirect_to :action 				   =>		"listInstitution"
		end
		
		@institute				               			= 		Hash.new
		Institution.all.each do |value|
								@institute[value.name] 				= 		value.id
							 end
							 
							 
		@skill				               				= 		Hash.new
		@subskill				               			= 		Hash.new
		@thirdSkill				               			= 		Hash.new
		@skill["Select Category"]						=		""
		@subskill["Select Speciality"]					=		""		
		Skill.where(:parentid => "0").all.each do |value|
													@skill[value.name] 				= 		value.id
												end
					 
								
		unless(params[:add].nil?)
			institution		  						= 		params[:institution]
			course									=		params[:course]
			cost									=		params[:cost]
			startdate								=		params[:date]			
			time									=		params[:time]
			skillID									=		params[:sel_group2]
			
			unless(course.nil?)
				course								=		Course.new(:institutionid => institution, :title => course, :startdate => startdate, :cost => cost, :timerequired => time)
				if(course.save == true)
					courseID						=		course.id
					Skill.push({:id => skillID}, :course => courseID)
					redirect_to :action 			=>		"listInstitution"
				end
			else
				@msg     							= 		"please Enter A Sun Skill"
			end
        end			
	end
	
	def addCompanyType
		unless(params[:cancel].nil?)
			redirect_to :action 				   =>		"listCompanyType"
		end
		
		unless(params[:add].nil?)
			comType	 			  					= 		params[:comType]
			description								=		params[:description]
			unless(comType.nil?)
				skills								=		Companytype.new(:name => comType, :description => description)
				if(skills.save == true)
					@msg     						= 		"successfully inserted"
					redirect_to :action 			=>		"listCompanyType"
				end
			end
        end
	end	
	
	def listCompanyType

		
		unless(params[:Addskill].blank?)
              redirect_to :action 					=>		"addCompanyType"
        end
        @count										=		0
		@cntArray      								= 		Array.new
		@totalcnt  									= 		Companytype.all.count
		cnt_data  									= 		Companytype.sort(:name).all
		 unless(cnt_data.nil?)
			cnt_data.each do |val|
								@cntArray.push(val.name)
						  end
	     end	
	end
	
	def csv_method
		unless(params[:add].blank?)
			require 'csv'
			@csv_text 					= 		params[:filename].tempfile.to_path.to_s
			@tags 						= 		CSV.read(@csv_text).flatten
			render :text => @tags 
		end	
	end
	
	private
	def require_login
		unless logged_in?
			redirect_to :action 					=>		"index"
		end
    
	end
	
	def logged_in?
		!!session[:username]
	end

	
end
