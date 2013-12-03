class EmployeeController < ApplicationController

require 'json'
	def login


		unless(params[:login].nil?)
			empUsName								=		params[:empUsName]
			empPass							    	=		params[:empPass]
			
			unless(empUsName.nil?)
				emp_data  							= 		Prospect.find_by_employeeusername(empUsName)
				unless(emp_data.nil?)
					password						=		emp_data.employeepassword
					unless(password.nil?)
						if(empPass == password)
							session[:username]		=		empUsName
							session[:userid]		=		emp_data.id
							session[:name]			=		emp_data.employeefirstname
							session[:lastname]		=		emp_data.employeelastname
							$fname					=		emp_data.employeefirstname
							$lname					=		emp_data.employeelastname
							$usid					=		emp_data.id
							redirect_to :action 	=>		"dashboard"
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
		session[:username]		=		nil
		session[:userid]		=		nil
		session[:name]			=		nil
		session[:lastname]		=		nil
		
		redirect_to :action 	=>		"homePage"
	end
	
	def addEmployee

		unless(params[:cancel].nil?)
			redirect_to :action 					=>		"login"
		end
				

		unless(params[:add].nil?)
			 empUsName								=		params[:name]
			 empemail	 			  				= 		params[:email]
			 emppassword	 			  			= 		params[:password]
			 empfname		  						= 		params[:fname]
			 emplname 			  					= 		params[:lname]
			 empmobile			  					= 		params[:mobile]
			 empaddress	 			  				= 		params[:addressline1]
			 city 				  					= 		params[:city]
			 state				  					= 		params[:state]
			 country	 			  				= 		params[:country]
			 zip		 			  				= 		params[:zip]
			
			unless(empUsName.nil?)
				  emp_data  						= 		Prospect.find_by_employeeusername(empUsName)
				  if(emp_data.nil?)
					  employee						=		Prospect.create(:employeeusername => empUsName, :employeepassword => emppassword, :employeefirstname => empfname, :employeelastname => emplname, :employeeaddress => empaddress, :employeeemail => empemail, :employeemobile => empmobile, :city => city, :state => state, :country => country, :zip => zip)
					  if(employee.save == true)
						  @msg     					= 		"successfully inserted"
						  session[:userid]			=		employee.id
						  session[:name]			=		employee.employeefirstname
						  session[:lastname]		=		employee.employeelastname
						  redirect_to :action 		=>		"portfolioNew"
					  end	  
				  else
					  session[:lmsg]     			= 		"Username already exist"
					  redirect_to :action 			=>		"addEmployee"
				  end  
			end	 
		end
	end             


	def addPrequisite
		unless(params[:cancel].nil?)
			redirect_to :action 				   =>		"listPrequisite"
		end
		
		unless(params[:add].nil?)
			prequisite	 		  					= 		params[:prequisite]
			description								=		params[:description]
			
			unless(prequisite.nil?)
				prequisites							=		Prequisite.new(:name => prequisite, :description => description)
				if(prequisites.save == true)
					@msg     						= 		"successfully inserted"
					redirect_to :action 			=>		"listPrequisite"
				end
			end
        end
	end
	
	def addSubPrequisite
		unless(params[:cancel].nil?)
			redirect_to :action 				   =>		"listPrequisite"
		end
		
		@prequisite			               			= 		Hash.new
		prequisite 						     		=  		params[:sel_group]
		Prequisite.where(:parentid => "0").all.each do |value|
														@prequisite[value.name] 				= 		value.id
													end
								
		unless(params[:add].nil?)
			subprequisite		  					= 		params[:prequisite]
			description								=		params[:description]
			
			unless(subprequisite.nil?)
				prequisites							=		Prequisite.new(:parentid => prequisite, :name => subprequisite, :description => description)
				if(prequisites.save == true)
					@msg     						= 		"successfully inserted"
					redirect_to :action 			=>		"listPrequisite"
				end
			else
				@msg     							= 		"please Enter A Sun Skill"
			end
        end						
	end
	
	def getSecondPre
		unless(params[:id].blank?)
			prequisite 								=  		params[:id].to_s
			unless(prequisite.nil?)
				@secondLevel	=	Prequisite.where(:parentid => prequisite).all
			end	
			render :json => @secondLevel.map{|c| [c.id, c.name]}
        end	
	end
	
	def addThirdLevelPrequisite
		@subprequisite			               		= 		Hash.new
		unless(params[:cancel].nil?)
			redirect_to :action 				   =>		"listPrequisite"
		end
		
		@prequisite			               			= 		Hash.new
		@prequisite["Select Category"]				=		""
		Prequisite.where(:parentid => "0").all.each do |value|
														@prequisite[value.name] 				= 		value.id
													end
								
		unless(params[:add].nil?)
			prequisite	  							=  		params[:sel_group1]
			subprequisite		  					= 		params[:prequisite]
			description								=		params[:description]
			
			unless(prequisite.nil?)
				prequisites							=		Prequisite.new(:parentid => prequisite.to_s, :name => subprequisite.to_s, :description => description.to_s)
				if(prequisites.save == true)
					@msg     						= 		"successfully inserted"
					redirect_to :action 			=>		"listPrequisite"
				end
			else
				@msg     							= 		"please Enter A Sun Skill"
			end
        end						
	end

	def listPrequisite
		
		unless(params[:Addskill].blank?)
              redirect_to :action 					=>		"addPrequisite"
        end
        
        unless(params[:Addsub].blank?)
              redirect_to :action 					=>		"addSubPrequisite"
        end
        
        unless(params[:AddThird].blank?)
              redirect_to :action 					=>		"addThirdLevelPrequisite"
        end
        
        @count										=		0
		@cntArray      								= 		Array.new
		@totalcnt  									= 		Prequisite.where(:parentid => "0").all.count
		cnt_data  									= 		Prequisite.where(:parentid => "0").all
		 unless(cnt_data.nil?)
			cnt_data.each do |val|
								@cntArray.push(val.name)
						 end
	     end	
	end
	
	def addSkill
		unless(params[:cancel].nil?)
			redirect_to :action 				   =>		"listSkill"
		end
		
		unless(params[:add].nil?)
			skill	 			  					= 		params[:skill]
			description								=		params[:description]
			
			unless(skill.nil?)
				skills								=		Skill.new(:name => skill, :description => description)
				if(skills.save == true)
					@msg     						= 		"successfully inserted"
					redirect_to :action 			=>		"listSkill"
				end
			end
        end
	end
	
	
	def addSubSkill
		unless(params[:cancel].nil?)
			redirect_to :action 				   =>		"listSkill"
		end
		
		@skill				               			= 		Hash.new
		skill	  						     		=  		params[:sel_group]
		Skill.where(:parentid => "0").all.each do |value|
													@skill[value.name] 				= 		value.id
												end
								
		unless(params[:add].nil?)
			subskill 			  					= 		params[:skill]
			description								=		params[:description]
			
			unless(subskill.nil?)
				skills								=		Skill.new(:parentid => skill, :name => subskill, :description => description)
				if(skills.save == true)
					@msg     						= 		"successfully inserted"
					redirect_to :action 			=>		"listSkill"
				end
			else
				@msg     							= 		"please Enter A Sun Skill"
			end
        end						
	end
	
	def getSecond
		unless(params[:id].blank?)
			skills	  								=  		params[:id].to_s
			unless(skills.nil?)
				@secondLevel	=	Skill.where(:parentid => skills).all
			end	
			render :json => @secondLevel.map{|c| [c.id, c.name]}
        end	
	end
	
	def addThirdLevel
		@subskill				               		= 		Hash.new
		unless(params[:cancel].nil?)
			redirect_to :action 				   =>		"listSkill"
		end
		
		@skill				               			= 		Hash.new
		@skill["Select Category"]					=		""
		Skill.where(:parentid => "0").all.each do |value|
													@skill[value.name] 				= 		value.id
												end
								
		unless(params[:add].nil?)
			skill	  								=  		params[:sel_group1]
			subskill 			  					= 		params[:Skill]
			description								=		params[:description]
			
			unless(skill.nil?)
				skills								=		Skill.new(:parentid => skill.to_s, :name => subskill.to_s, :description => description.to_s)
				if(skills.save == true)
					@msg     						= 		"successfully inserted"
					redirect_to :action 			=>		"listSkill"
				end
			else
				@msg     							= 		"please Enter A Sun Skill"
			end
        end						
	end
	
	
	
	def listSkill
		
		unless(params[:Addskill].blank?)
              redirect_to :action 					=>		"addSkill"
        end
        
        unless(params[:Addsub].blank?)
              redirect_to :action 					=>		"addSubSkill"
        end
        
        unless(params[:AddThird].blank?)
              redirect_to :action 					=>		"addThirdLevel"
        end
        
        @count										=		0
		@cntArray      								= 		Array.new
		@totalcnt  									= 		Skill.where(:parentid => "0").all.count
		cnt_data  									= 		Skill.where(:parentid => "0").sort(:skill).all
		 unless(cnt_data.nil?)
			cnt_data.each do |val|
								@cntArray.push(val.name)
						 end
	     end	
	end
	
	def popSecond
		@subskill				               		= 		Hash.new
		unless(params[:id].blank?)
			skills	  								=  		params[:id].to_s
			unless(skills.nil?)
				@text	=	Skill.where(:parentid => skills).all
			end	
			render :json => @text.map{|c| [c.id, c.name]}
        end	
	end
	
	def PopThird
		@subskill				               		= 		Hash.new
		unless(params[:id].blank?)
			skills	  								=  		params[:id].to_s
			unless(skills.nil?)
				@text	=	Skill.where(:parentid => skills).sort(:name).all
			end	
			render :json => @text.map{|c| [c.id, c.name]}
        end	
	end
	
	def addAskill
		portSkill																			=		Array.new
		keywordsId																			=		Array.new
		unless(params[:id].blank?)
			data 																			= 		session[:userid]
			skillId																			=		params[:id]
			keywordsId.push(skillId.to_s)
			unless(data.to_s.nil?)
				port																		=		Portfolio.find_by_ownerid(data.to_s)
				unless(port.blank?)
					prot																	=		port.id.to_s
					Portfolioitem.where(:portfolioid =>prot.to_s).all.each  do |va|
																				portId		=		va.id
																				portSkill.push((Portfolioitemskill.find_by_portfolioitemid(portId.to_s)).skillid.to_s)
																			end
					portSkill							   									= 		portSkill.uniq	
					unless((keywordsId - portSkill).empty?)
						unless(data.to_s.nil?)
							  emp_data  													= 		Portfolio.find_by_ownerid(data.to_s)
							  if(emp_data.nil?)
								  portfolioData												=		Portfolio.new(:ownerid => data.to_s)
								  if(portfolioData.save == true)
										Portfolio.sort(:created_at.desc).limit(1).each do |val|
																							@portfolioid		=		val.id
																						end
										unless(@portfolioid.blank?)	
											portfolioItemData								=		Portfolioitem.new(:portfolioid => @portfolioid, :portfolioitemtypeid => "51cad36df1bb550e28000242")
											if(portfolioItemData.save == true)
											
												Portfolioitem.sort(:created_at.desc).limit(1).each do |valu|
																										@portfolioItemId		=		valu.id
																									end
												unless(@portfolioItemId.nil?)
													newSkill								=		Portfolioitemskill.new(:portfolioitemid => @portfolioItemId, :skillid => skillId)
													if(newSkill.save == true)
														portSkill							= 		portSkill.clear
														keywordsId							= 		keywordsId.clear
														@text								=	"1"
														render :json => @text
													end
												end	
											end											  
										end											  
								  end	  
							  else
								  emp_datas  												= 		Portfolio.find_by_ownerid(data.to_s)
								  unless(emp_datas.blank?)
									  @portfolioid										    =		emp_datas.id
									  portfolioItemData										=		Portfolioitem.new(:portfolioid => @portfolioid, :portfolioitemtypeid => "51cad36df1bb550e28000242")
									  if(portfolioItemData.save == true)
										   Portfolioitem.sort(:created_at.desc).limit(1).each do |val|
																								  @portfolioItemId		=		val.id
																							  end
										   unless(@portfolioItemId.blank?)
											  newSkill										=		Portfolioitemskill.new(:portfolioitemid => @portfolioItemId, :skillid => skillId)
											  if(newSkill.save == true)
												  portSkill									= 		portSkill.clear
												  keywordsId								= 		keywordsId.clear
												  @text										=		"1"
												  render :json => @text
											  end
										  end	
									  end	
								  end					  
							  end  
						else
							redirect_to :action 			=>		"login"
						end	
					else
						portSkill															= 		portSkill.clear
						keywordsId															= 		keywordsId.clear
						@text																=		"1"
						render :json => @text	
					end
				else
					unless(data.to_s.nil?)
						  emp_data  													= 		Portfolio.find_by_ownerid(data.to_s)
						  if(emp_data.nil?)
							  portfolioData												=		Portfolio.new(:ownerid => data.to_s)
							  if(portfolioData.save == true)
									Portfolio.sort(:created_at.desc).limit(1).each do |val|
																						@portfolioid		=		val.id
																					end
									unless(@portfolioid.blank?)	
										portfolioItemData								=		Portfolioitem.new(:portfolioid => @portfolioid, :portfolioitemtypeid => "51cad36df1bb550e28000242")
										if(portfolioItemData.save == true)
										
											Portfolioitem.sort(:created_at.desc).limit(1).each do |valu|
																									@portfolioItemId		=		valu.id
																								end
											unless(@portfolioItemId.nil?)
												newSkill								=		Portfolioitemskill.new(:portfolioitemid => @portfolioItemId, :skillid => skillId)
												if(newSkill.save == true)
													portSkill							= 		portSkill.clear
													keywordsId							= 		keywordsId.clear
													@text								=	"1"
													render :json => @text
												end
											end	
										end											  
									end											  
							  end	  
						  else
							  emp_datas  												= 		Portfolio.find_by_ownerid(data.to_s)
							  unless(emp_datas.blank?)
								  @portfolioid										    =		emp_datas.id
								  portfolioItemData										=		Portfolioitem.new(:portfolioid => @portfolioid, :portfolioitemtypeid => "51cad36df1bb550e28000242")
								  if(portfolioItemData.save == true)
									   Portfolioitem.sort(:created_at.desc).limit(1).each do |val|
																							  @portfolioItemId		=		val.id
																						  end
									   unless(@portfolioItemId.blank?)
										  newSkill										=		Portfolioitemskill.new(:portfolioitemid => @portfolioItemId, :skillid => skillId)
										  if(newSkill.save == true)
											  portSkill									= 		portSkill.clear
											  keywordsId								= 		keywordsId.clear
											  @text										=		"1"
											  render :json => @text
										  end
									  end	
								  end	
							  end					  
						  end  
					else
						redirect_to :action 			=>		"login"
					end	
				end	
			end	
        end				
	end
	
	def addMyskillsPortfolio
		@skill				               				= 		Hash.new
		@subskill				               			= 		Hash.new
		@thirdSkill				               			= 		Hash.new
		@skill["Select Category"]						=		""
		@subskill["Select Speciality"]					=		""		
		Skill.where(:parentid => "0").all.each do |value|
													@skill[value.name] 				= 		value.id
												end

        unless(params[:add].blank?)
			data 																= 		session[:userid]
			unless(data.to_s.nil?)
				  emp_data  													= 		Portfolio.find_by_ownerid(data.to_s)
				  if(emp_data.nil?)
					  portfolioData												=		Portfolio.new(:ownerid => data.to_s)
					  if(portfolioData.save == true)
							Portfolio.sort(:created_at.desc).limit(1).each do |val|
																				@portfolioid		=		val.id
																			end
							unless(@portfolioid.blank?)	
								portfolioItemData								=		Portfolioitem.new(:portfolioid => @portfolioid, :portfolioitemtypeid => "51cad36df1bb550e28000242")
								if(portfolioItemData.save == true)
								
									Portfolioitem.sort(:created_at.desc).limit(1).each do |valu|
																							@portfolioItemId		=		valu.id
																						end
									unless(@portfolioItemId.nil?)
										tagAry  								=  		params[:skill]	
										unless(tagAry.blank?)
											tagAry.each do |vale|
															Portfolioitemskill.create(:portfolioitemid => @portfolioItemId, :skillid => vale)
														end
														redirect_to :action 	=>		"myskillsPortfolio"
										end				
									end	
								end											  
							end											  
					  end	  
				  else
						
						emp_datas  												= 		Portfolio.find_by_ownerid(data.to_s)
						unless(emp_datas.blank?)
							@portfolioid										=		emp_datas.id
							portfolioItemData									=		Portfolioitem.new(:portfolioid => @portfolioid, :portfolioitemtypeid => "51cad36df1bb550e28000242")
							if(portfolioItemData.save == true)
							
								Portfolioitem.sort(:created_at.desc).limit(1).each do |val|
																						@portfolioItemId		=		val.id
																					end
								unless(@portfolioItemId.blank?)
									
									tagAry  									=  		params[:skill]	
									unless(tagAry.blank?)
										tagAry.each do |vale|
														Portfolioitemskill.create(:portfolioitemid => @portfolioItemId, :skillid => vale, )
													end
													redirect_to :action 		=>		"myskillsPortfolio"
									end				
								end	
							end	
						end					  
				  end  
			else
				redirect_to :action 			=>		"login"
			end	 
        end	
        
        
        
        @skillName			      								= 		Array.new
		@first													= 		Array.new
        data 													= 		session[:userid]
		emp_data  												= 		Portfolio.find_by_ownerid(data.to_s)
		unless(emp_data.nil?)
			@portfolioid										=		emp_data.id
			unless(@portfolioid.nil?)
				Portfolioitem.where(:portfolioid => @portfolioid.to_s).each do |val|
																				@portfolioitemID	=	val.id
																				unless(@portfolioitemID.to_s.nil?)
																					Portfolioitemskill.where(:portfolioitemid => @portfolioitemID.to_s).each do |value|
																																								@portfolioitemskillID	=	value.id
																																								@skillID				=	value.skillid
																																								unless(@portfolioitemskillID.to_s.nil?)
																																									data	=	Skill.find_by_id(@skillID.to_s)
																																									unless(data.to_s.nil?)
																																										@skillName.push("skillname" => data.name , "portfolioskillid" => @portfolioitemskillID , "parentid" => data.parentid)
																																										
																																									end
																																								 end																																	
																																								 
																																							 end
																																						
																				end														
																			end
			end
			unless(@skillName.blank?)
				@skillName.sort_by! {|e| e["parentid"] }.reverse
				@first.push(@skillName[0])
				unless(@first.blank?)
					@first.each do |va| 
									 @b = va['parentid'] 
								 end 
				end	
			end		
		end		 
		
						
	end
	
	def myskillsForAddMyskill
		
		@skillName			      								= 		Array.new
		@first													= 		Array.new
        data 													= 		session[:userid]
		emp_data  												= 		Portfolio.find_by_ownerid(data.to_s)
		unless(emp_data.nil?)
			@portfolioid										=		emp_data.id
			unless(@portfolioid.nil?)
				Portfolioitem.where(:portfolioid => @portfolioid.to_s).each do |val|
																				@portfolioitemID	=	val.id
																				unless(@portfolioitemID.to_s.nil?)
																					Portfolioitemskill.where(:portfolioitemid => @portfolioitemID.to_s).each do |value|
																																								@portfolioitemskillID	=	value.id
																																								@skillID				=	value.skillid
																																								unless(@portfolioitemskillID.to_s.nil?)
																																									data	=	Skill.find_by_id(@skillID.to_s)
																																									unless(data.to_s.nil?)
																																										@skillName.push("skillname" => data.name , "portfolioskillid" => @portfolioitemskillID , "parentid" => data.parentid)
																																										
																																									end
																																								 end																																	
																																								 
																																							 end
																																						
																				end														
																			end
			end
			unless(@skillName.blank?)
				@skillName.sort_by! {|e| e["parentid"] }.reverse
				@first.push(@skillName[0])
				unless(@first.blank?)
					@first.each do |va| 
									 @b = va['parentid'] 
								 end 
				end	
			end	
		end	
		render :layout => false	 
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
	end
	
	def addSkillNew
		@skillDetails					=		Array.new
		info							=		Portfolio.find_by_ownerid(session[:userid].to_s)
		information						=		info.id	
		unless(information.nil?)
			Portfolioitem.where(:portfolioid =>information.to_s).all.each do |valu|
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
	  
					@skillDetails.push("categoryName" => categoryName, "specialityName" => specialityName, "skillName" => skillName)
				end
		end	
	end	
		
	def portfolioNew
		@dataARY      							= 		Array.new	
		@cntArray      							= 		Array.new
		@skillDetails							=		Array.new
		@eduArray      							= 		Array.new
		@resArray      							= 		Array.new
		@count									=		0
		@counts									=		0
			
		unless(params[:addSkill].blank?)
			redirect_to :action 				=>		"addMyskillsPortfolio"
        end
       		
		unless(session[:userid].blank?)
			info								=		Portfolio.find_by_ownerid(session[:userid].to_s)
			
			unless(info.nil?)   
			
				resumedata						=		info.resume
				unless(resumedata.nil?)
					resumedata.each do |val|
										@resArray.push("name" => val.name , "created_at" => val.created_at)
								   end
				end 
				
			  
				history							=		info.workhistory
				unless(history.nil?)
					history.each do |val|
										@cntArray.push("workid" => val.id , "title" => val.title , "company" => val.company , "fromdate" => val.fromdate , "tilldate" => val.tilldate)
								 end
				end
				
				education						=		info.education
				unless(education.nil?)
					education.each do |edu|
										@eduArray.push("educationID" => edu.id.to_s , "degree" => edu.degree , "college" => edu.college , "date" => edu.date, "field" => edu.field)
								   end
				end
					
				information						=		info.id	
				unless(information.nil?)
					Portfolioitem.where(:portfolioid =>information.to_s).all.each do |valu|
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
									  
							@skillDetails.push("categoryName" => categoryName, "specialityName" => specialityName, "skillName" => skillName , "skillProficency" => @prof , "skillID" => skillID, "portfolioitemskillId" => skill.id)
						end
				end	
			end	
			
			data									=		Prospect.find_by_id(session[:userid].to_s.to_s)
			@dataARY.push("firstname" => data.employeefirstname, "lastname" => data.employeelastname, "address" => data.employeeaddress, "city" => data.city, "state" => data.state, "country" => data.country, "zip" => data.zip , "mobile" => data.employeemobile, "username" => data.employeeusername , "twitter" => data.twitter, "linkedin" => data.linkedin)
		end	 
	end
	
	def skillvalidate
		unless(params[:skillID].blank?)
			skillInfo											=		Skill.find_by_id(params[:skillID].to_s)
			@skillName											=		skillInfo.name
        end
	end
	
	def editskill
		@dataAry							=		Array.new
		@certi								=		Array.new
		@exampl								=		Array.new
		@refer								=		Array.new
		
		unless(params[:portId].to_s.nil?)
			Portfolioitemskill.where(:id => params[:portId].to_s).each do |value|
				@skillID					=		value.skillid
				unless(@skillID.to_s.nil?)
					skillInfo	=	Skill.find_by_id(@skillID.to_s)
					unless(skillInfo.to_s.nil?)
						skillName			=		skillInfo.name
						skillParent			=		skillInfo.parentid
						
						specialityInfo		=		Skill.find_by_id(skillParent.to_s)
						specialityName		=		specialityInfo.name
						speciality			=		specialityInfo.parentid
						
						categoryInfo		=		Skill.find_by_id(speciality.to_s).name
						@dataAry.push("skillname" => skillName , "portfolioskillid" => params[:portId].to_s , "speciality" => specialityName, "category" => categoryInfo)
						
						 @empVaule	=	value.value
						 unless(@empVaule.blank?)
							@empVaule.each do |vale|
											   @certificates		=		vale.certificate
											   @references			=		vale.reference
											   @examples			=		vale.example
											   
											   @prof				=		vale.proficency
											   @exp					=		vale.experience
											   unless(@certificates.nil?)
												   @certificates.each do |vle|
																		  @certi.push("certificate" => vle.certname , "description" => vle.certdescription)
																	  end
											   end
											   unless(@examples.nil?)
												   @examples.each do |vle|
																		  @exampl.push("example" => vle.examplename , "description" => vle.exampledescription)
																	  end
											   end
											   unless(@references.nil?)
												   @references.each do |vle|
																		  @refer.push("reference" => vle.refname , "description" => vle.refdescription)
																	  end
											   end
											   
											end   				   
											
						end
					end
				 end
			 end
		end
	end
	
	def myskillsPortfolio
		@skillName			      								= 		Array.new
		@first													= 		Array.new
		unless(params[:add].blank?)
			redirect_to :action 								=>		"addMyskillsPortfolio"
        end
        data 													= 		session[:userid]
		emp_data  												= 		Portfolio.find_by_ownerid(data.to_s)
		unless(emp_data.nil?)
			@portfolioid										=		emp_data.id
			unless(@portfolioid.nil?)
				Portfolioitem.where(:portfolioid => @portfolioid.to_s).each do |val|
																				@portfolioitemID	=	val.id
																				unless(@portfolioitemID.to_s.nil?)
																					Portfolioitemskill.where(:portfolioitemid => @portfolioitemID.to_s).each do |value|
																																								@portfolioitemskillID	=	value.id
																																								@skillID				=	value.skillid
																																								unless(@portfolioitemskillID.to_s.nil?)
																																									data	=	Skill.find_by_id(@skillID.to_s)
																																									unless(data.to_s.nil?)
																																										@skillName.push("skillname" => data.name , "portfolioskillid" => @portfolioitemskillID , "parentid" => data.parentid)
																																										
																																									end
																																								 end																																	
																																								 
																																							 end
																																						
																				end														
																			end
			end
			unless(@skillName.blank?)
				@skillName.sort_by! {|e| e["parentid"] }.reverse
				@first.push(@skillName[0])
				unless(@first.blank?)
					@first.each do |va| 
									 @b = va['parentid'] 
								 end 
				end	
			end		
		end		 
	end
	
	def changeProficency
		unless(params[:id].to_s.nil?)
			unless(params[:id].to_s.blank?)
				proficency													=		params[:proficency]
				unless(proficency.blank?)
					emp_data  												= 		Portfolioitemskill.find_by_id(params[:id].to_s)
					unless(emp_data.nil?)
						values 												= 		emp_data.value
						if(values.blank?)
							cntins  										= 		Value.new(:proficency => proficency)
							emp_data.value << cntins
							emp_data.save
						
							if(cntins.save == true)
								@msg     									= 		"successfully inserted"
								@text					=	"1"
								render :json => @text 
							end 
						else	
							values.each do |tag| 
											tag.proficency 					=		proficency
											result  						= 		emp_data.save
											if(result == true)
												@msg     					= 		"successfully inserted"  
												@text					=	"1"
												render :json => @text
											end
										end
						end
					end						
				end
			end
		end
	end	
	
	def changeExperience
		unless(params[:id].to_s.nil?)
			unless(params[:id].to_s.blank?)
				experience													=		params[:experience]
				unless(experience.blank?)
					emp_data  												= 		Portfolioitemskill.find_by_id(params[:id].to_s)
					unless(emp_data.nil?)
						values 												= 		emp_data.value
						if(values.blank?)
							cntins  										= 		Value.new(:experience => experience)
							emp_data.value << cntins
							emp_data.save
						
							if(cntins.save == true)
								@msg     									= 		"successfully inserted"
								@text					=	"1"
								render :json => @text 
							end 
						else	
							values.each do |tag| 
											tag.experience 					=		experience
											result  						= 		emp_data.save
											if(result == true)
												@msg     					= 		"successfully inserted"  
												@text					=	"1"
												render :json => @text
											end
										end
						end
					end						
				end
			end
		end
	end		
	
	def jQueryaccessMyskill
		unless(params[:id].nil?)
			$portify												=		params[:id]
			@def													=		1
			@certi				      								= 		Array.new
			@exampl				      								= 		Array.new
			@refer				      								= 		Array.new
			@prof													=		1	
			@exp													=		1
			data 													= 		session[:userid]
			emp_data  												= 		Portfolio.find_by_ownerid(data.to_s)
			unless(emp_data.nil?)
				@portfolioid										=		emp_data.id
				unless(@portfolioid.nil?)
					Portfolioitem.where(:portfolioid => @portfolioid.to_s).each do |val|
																					@portfolioitemID	=	val.id
																					unless(@portfolioitemID.to_s.nil?)
																						empData		=		Portfolioitemskill.where(:portfolioitemid => @portfolioitemID.to_s , :id =>params[:id].to_s)
																						unless(empData.nil?)
																							empData.each do |dta|
																											 @empVaule	=	dta.value
																												 unless(@empVaule.blank?)
																													@empVaule.each do |vale|
																																	   @certificates		=		vale.certificate
																																	   @references			=		vale.reference
																																	   @examples			=		vale.example
																																	   
																																	   @prof				=		vale.proficency
																																	   @exp					=		vale.experience
																																	   unless(@certificates.nil?)
																																		   @certificates.each do |vle|
																																								  @certi.push("certificate" => vle.certname , "description" => vle.certdescription)
																																							  end
																																	   end
																																	   unless(@examples.nil?)
																																		   @examples.each do |vle|
																																								  @exampl.push("example" => vle.examplename , "description" => vle.exampledescription)
																																							  end
																																	   end
																																	   unless(@references.nil?)
																																		   @references.each do |vle|
																																								  @refer.push("reference" => vle.refname , "description" => vle.refdescription)
																																							  end
																																	   end
																																	   
																																	end   				   
																																	
																												 end
																										  end	 
																						end				 																								
																					end	
																				end
																				
				end
				render :json => {
								  :prof => @prof,
								  :id => params[:id],
								  :exp => @exp,
								  :certificate => @certi,
								  :example => @exampl,
								  :refer => @refer
							   }
			end
			
			
		end	
	end	
	
	def accessMyskill
		@def													=		1
		@certi				      								= 		Array.new
		@exampl				      								= 		Array.new
		@refer				      								= 		Array.new
		
        data 													= 		session[:userid]
		emp_data  												= 		Portfolio.find_by_ownerid(data.to_s)
		unless(emp_data.nil?)
			@portfolioid										=		emp_data.id
			unless(@portfolioid.nil?)
				Portfolioitem.where(:portfolioid => @portfolioid.to_s).each do |val|
																				@portfolioitemID	=	val.id
																				unless(@portfolioitemID.to_s.nil?)
																					empData		=		Portfolioitemskill.where(:portfolioitemid => @portfolioitemID.to_s , :id =>params[:id].to_s)
																					unless(empData.nil?)
																						empData.each do |dta|
																										 @empVaule	=	dta.value
																											 unless(@empVaule.blank?)
																												@empVaule.each do |vale|
																																   @certificates		=		vale.certificate
																																   @references			=		vale.reference
																																   @examples			=		vale.example
																																   
																																   @prof				=		vale.proficency
																																   @exp					=		vale.experience
																																   unless(@certificates.nil?)
																																	   @certificates.each do |vle|
																																							  @certi.push("certificate" => vle.certname , "description" => vle.certdescription)
																																						  end
																																   end
																																   unless(@examples.nil?)
																																	   @examples.each do |vle|
																																							  @exampl.push("example" => vle.examplename , "description" => vle.exampledescription)
																																						  end
																																   end
																																   unless(@references.nil?)
																																	   @references.each do |vle|
																																							  @refer.push("reference" => vle.refname , "description" => vle.refdescription)
																																						  end
																																   end
																																   
																																end   				   
																																
																											 end
																									  end	 
																					end				 																								
																				end	
																			end
			end
		end	
	
		unless(params[:submit].blank?)
			unless(params[:id].blank?)
                @portfolioSkillID    		  									= 		params[:id]
				unless(@portfolioSkillID.blank?)
					proficency													=		params[:proficency]
					experience													=		params[:experience]
					unless(proficency.blank?)
						emp_data  												= 		Portfolioitemskill.find_by_id(@portfolioSkillID)
						unless(emp_data.nil?)
							values 												= 		emp_data.value
							if(values.blank?)

								cntins  										= 		Value.new(:proficency => proficency, :experience => experience)
								emp_data.value << cntins
								emp_data.save
							
								if(cntins.save == true)
									@msg     									= 		"successfully inserted"
									redirect_to :action							=>		"myskillsPortfolio"
								end 
							else	
								values.each do |tag| 
												tag.proficency 					=		proficency
												tag.experience					=		experience
												result  						= 		emp_data.save
												if(result == true)
													@msg     					= 		"successfully inserted"  
													redirect_to :action			=>		"myskillsPortfolio"
												end
											end
							end
						end						
					end
				end
			end
		end	  
	end
	
	def myCertificates
		@id			=		params[:portId].to_s
	end
	
	def myCert
		unless(params[:id].blank?)
			@portfolioSkillID    		  									= 		params[:id]
			unless(@portfolioSkillID.blank?)
				certificate													=		params[:degree]
				description													=		params[:university]
				unless(certificate.nil?)
					emp_data  												= 		Portfolioitemskill.find_by_id(@portfolioSkillID.to_s)
					unless(emp_data.nil?)
						values 												= 		emp_data.value
						unless(values.blank?)
							values.each do |val|
											@cert							=		val.certificate
										end
							
							if(@cert)
								certdata  									= 		Certificate.new(:certname => certificate, :certdescription => description)
								emp_data.value.each do |valu|
														@cert							=		valu.certificate
														@cert << certdata
													end
								emp_data.save
							
								if(certdata.save == true)
									@msg     								= 		"successfully inserted"
									 render :json => {
													   :certificate => certificate,
													   :description => description
													 }
								end 
							end
						else
							cntins  										= 		Value.new(:proficency => 1.to_i, :experience => 1.to_i)
							emp_data.value << cntins
							emp_data.save
							
							if(cntins.save == true)
								values 												= 		emp_data.value
								unless(values.blank?)
									values.each do |val|
													@cert							=		val.certificate
												end
									
									if(@cert)
										certdata  									= 		Certificate.new(:certname => certificate, :certdescription => description)
										emp_data.value.each do |valu|
																@cert							=		valu.certificate
																@cert << certdata
															end
										emp_data.save
									
										if(certdata.save == true)
											@msg     								= 		"successfully inserted"
											render :json => {
															   :certificate => certificate,
															   :description => description
															} 
										end 
									end
								end	
							end 	
						end	
					end						
				end
			end
		end	  
	end

	def myExamples
		@id			=		params[:portId].to_s
	end
	
	def myEg
		unless(params[:id].blank?)
			@portfolioSkillID    		  									= 		params[:id]
			unless(@portfolioSkillID.blank?)
				examples													=		params[:eg]
				description													=		params[:description]
				unless(examples.nil?)
					emp_data  												= 		Portfolioitemskill.find_by_id(@portfolioSkillID.to_s)
					unless(emp_data.nil?)
						values 												= 		emp_data.value
						unless(values.blank?)
							values.each do |val|
											@cert							=		val.example
										end
							
							if(@cert)
								certdata  									= 		Example.new(:examplename => examples, :exampledescription => description)
								emp_data.value.each do |valu|
														@cert							=		valu.example
														@cert << certdata
													end
								emp_data.save
							
								if(certdata.save == true)
									@msg     								= 		"successfully inserted"
									render :json => {
													   :examples => examples,
													   :description => description
													 }
									
								end 
							end
						else
							cntins  										= 		Value.new(:proficency => 1.to_i, :experience => 1.to_i)
							emp_data.value << cntins
							emp_data.save
							
							if(cntins.save == true)
								values 												= 		emp_data.value
								unless(values.blank?)
									values.each do |val|
													@cert							=		val.example
												end
									
									if(@cert)
										certdata  									= 		Example.new(:examplename => examples, :exampledescription => description)
										emp_data.value.each do |valu|
																@cert							=		valu.example
																@cert << certdata
															end
										emp_data.save
									
										if(certdata.save == true)
											@msg     								= 		"successfully inserted"
											render :json => {
													   :examples => examples,
													   :description => description
													 }
										end 
									end
								end	
							end 	
						end	
					end						
				end
			end
		end	  
	end
	
	def myReferences
		@id			=		params[:portId].to_s
	end
	
	def myRefer
		unless(params[:id].blank?)
			@portfolioSkillID    		  									= 		params[:id]
			unless(@portfolioSkillID.to_s.blank?)
				reference													=		params[:reference]
				description													=		params[:description]
				unless(reference.nil?)
					emp_data  												= 		Portfolioitemskill.find_by_id(@portfolioSkillID.to_s)
					unless(emp_data.nil?)
						values 												= 		emp_data.value
						unless(values.blank?)
							values.each do |val|
											@cert							=		val.reference
										end
							
							if(@cert)
								certdata  									= 		Reference.new(:refname => reference, :refdescription => description)
								emp_data.value.each do |valu|
														@cert							=		valu.reference
														@cert << certdata
													end
								emp_data.save
							
								if(certdata.save == true)
									@msg     								= 		"successfully inserted"
									render :json => {
													   :reference => reference,
													   :description => description
													 }
								end 
							end
						else
							cntins  										= 		Value.new(:proficency => 1.to_i, :experience => 1.to_i)
							emp_data.value << cntins
							emp_data.save
							
							if(cntins.save == true)
								values 												= 		emp_data.value
								unless(values.blank?)
									values.each do |val|
													@cert							=		val.reference
												end
									
									if(@cert)
										certdata  									= 		Reference.new(:refname => reference, :refdescription => description)
										emp_data.value.each do |valu|
																@cert							=		valu.reference
																@cert << certdata
															end
										emp_data.save
									
										if(certdata.save == true)
											@msg     								= 		"successfully inserted"
											render :json => {
													   :reference => reference,
													   :description => description
													 }
										end 
									end
								end	
							end 	
						end	
					end						
				end
			end
		end	  	
	end
		
	def myWorkHistory
		@cntArray      							= 		Array.new
		@data 									= 		session[:userid] 
		unless(@data.to_s.nil?)
			emp_data  							= 		Portfolio.find_by_ownerid(@data.to_s)
			unless(emp_data.nil?)       
				history							=		emp_data.workhistory
				unless(history.nil?)
					history.each do |val|
										@cntArray.push("title" => val.title , "company" => val.company , "fromdate" => val.fromdate , "tilldate" => val.tilldate)
								 end
				end
			end					 
        end  
	end	
	
	def myWorkDashboard
		@cntArray      							= 		Array.new
		@data 									= 		session[:userid] 
		@count									=		0
		unless(@data.to_s.nil?)
			emp_data  							= 		Portfolio.find_by_ownerid(@data.to_s)
			unless(emp_data.nil?)       
				history							=		emp_data.workhistory
				unless(history.nil?)
					history.each do |val|
										@cntArray.push("workid" => val.id , "title" => val.title , "company" => val.company , "fromdate" => val.fromdate , "tilldate" => val.tilldate)
								 end
				end
			end					 
        end  
	end
	
	def editWorkHistory
		@dataARY      								= 		Array.new
		@data 										= 		session[:userid] 
		@workHistoryID								= 		params[:workID]
		unless(params[:workID].blank?)
			unless(@data.to_s.nil?)
				emp_data  							= 		Portfolio.find_by_ownerid(@data.to_s)
				unless(emp_data.nil?)
					workhistory						= 		emp_data.workhistory
					unless(workhistory.nil?)
						workhistory.each do |val|
											if(val.id.to_s == params[:workID].to_s)
												@dataARY.push("title" => val.title , "company" => val.company , "fromdate" => val.fromdate , "tilldate" => val.tilldate)
											end	
										 end	
					end
				end
			end	
		end
	end
	
	def updateWorkHistory
		unless(params[:company].nil?)
			company													=		params[:company]
			job	 			  										= 		params[:job]
			from	 			  									= 		params[:from]
			till	 			  									= 		params[:till]
			workHistoryID			  								= 		params[:workHistoryID]
			@data 													= 		session[:userid] 
			
			unless(@data.to_s.nil?)
				emp_data  											= 		Portfolio.find_by_ownerid(@data.to_s)
				unless(emp_data.nil?)
					workhistory										= 		emp_data.workhistory
					unless(workhistory.nil?)
						workhistory.each do |val|
											if(val.id.to_s == workHistoryID.to_s)
												val.company			=		company
												val.title			=		job
												val.fromdate		=		from
												val.tilldate		=		till
												result  			= 		emp_data.save
												if(result == true)
													@text					=	"1"
													render :json => @text
												end
											end	
										end		
					end	
				end
			end		
		end	
	end		
	
	def myResumeDashboard	
		@cntArray      							= 		Array.new
		@data 									= 		session[:userid] 
		unless(@data.to_s.nil?)
			emp_data  							= 		Portfolio.find_by_ownerid(@data.to_s)
			unless(emp_data.nil?)       
				resumedata						=		emp_data.resume
				unless(resumedata.nil?)
					resumedata.each do |val|
										@cntArray.push("name" => val.name , "created_at" => val.created_at)
								   end
				end
			end					 
        end 
	end	
	
	def myWorkHistoryPopup
	end
	
	def myWorkPopup
		unless(params[:job].nil?)
			job										=		params[:job]
			company	 			  					= 		params[:company]
			from	 			  					= 		params[:from]
			till		  							= 		params[:till]
			@data 									= 		session[:userid] 
			
			unless(@data.to_s.nil?)
				emp_data  							= 		Portfolio.find_by_ownerid(@data.to_s)
				unless(emp_data.nil?)
					unless(job.nil?)
						cntins  					= 		Workhistory.new(:title => job, :company => company, :fromdate => from, :tilldate => till)
						emp_data.workhistory << cntins
						emp_data.save
					
						if(cntins.save == true)
							@msg     				= 		"successfully inserted"
							@text					=	"1"
							render :json => @text
						end 
					end
					
				end
				
			end
		end	
	end
	
	
	def myResume
		@cntArray      							= 		Array.new
		@data 									= 		session[:userid] 
		unless(@data.to_s.nil?)
			emp_data  							= 		Portfolio.find_by_ownerid(@data.to_s)
			unless(emp_data.nil?)       
				resumedata						=		emp_data.resume
				unless(resumedata.nil?)
					resumedata.each do |val|
										@cntArray.push("name" => val.name , "created_at" => val.created_at)
								   end
				end
			end					 
        end 
	end
	
	def myEducation
		@cntArray      							= 		Array.new
		@data 									= 		session[:userid] 
		unless(@data.to_s.nil?)
			emp_data  							= 		Portfolio.find_by_ownerid(@data.to_s)
			unless(emp_data.nil?)       
				education						=		emp_data.education
				unless(education.nil?)
					education.each do |val|
										@cntArray.push("degree" => val.degree , "college" => val.college , "date" => val.date)
								 end
				end
			end					 
        end 
	end

	def openApplication
		@cntArray      							= 		Array.new
		@data 									= 		session[:userid] 
		@count									=		0
		@watchArray    							= 		Array.new
		@cnt									=		0
		
		unless(@data.to_s.nil?)
			emp_data  							= 		Prospect.find_by_id(@data.to_s)
			unless(emp_data.nil?)       
				applied							=		emp_data.jobsapplied
				invited							=		emp_data.invited
				applied							= 		applied.uniq
				invited							= 		invited.uniq
				watched							=		emp_data.jobswatched
				watched							= 		watched.uniq
				
				unless(applied.blank?)
					applied.each do |val|
									 jobData	=		Jobposting.find_by_id(val.to_s)
									 if(invited.include?(val))
										@status	=		"Invited"
									 else
										@status	=		"Not Invited yet"
									 end
									 @cntArray.push("job" => (jobData.description) , "company" => (Employer.find_by_id(jobData.postingcompany).name) , "status" => @status, "closed" => "Open")
							     end
				end
				unless(watched.blank?)
					watched.each do |val|
									 jobData	=		Jobposting.find_by_id(val.to_s)
									 @watchArray.push("job" => (jobData.description) , "company" => (Employer.find_by_id(jobData.postingcompany).name))
								end
				end	
			end					 
        end
	end
	
	def watchedJobs
		@data 									= 		session[:userid]
		jobID									=		params[:jobID]
		unless(@data.to_s.nil?)
			Prospect.push({:id => @data.to_s}, :jobswatched => jobID.to_s)
			redirect_to :action 				=>		"dashboard"				 
        end 
	end
	
	def myWatchedJobs
		@cntArray      							= 		Array.new
		@data 									= 		session[:userid] 
		@count									=		0
		unless(@data.to_s.nil?)
			emp_data  							= 		Prospect.find_by_id(@data.to_s)
			unless(emp_data.nil?)       
				applied							=		emp_data.jobswatched
				applied							= 		applied.uniq
				unless(applied.blank?)
					applied.each do |val|
									 jobData	=		Jobposting.find_by_id(val.to_s)
									 @cntArray.push("job" => (jobData.description) , "company" => (Employer.find_by_id(jobData.postingcompany).name))
								end
				end				
			end					 
        end 
	end	
	
	def myEducationDashboard
		@eduArray      							= 		Array.new
		@data 									= 		session[:userid] 
		@count									=		0	
		unless(@data.to_s.nil?)
			emp_data  							= 		Portfolio.find_by_ownerid(@data.to_s)
			unless(emp_data.nil?)       
				education						=		emp_data.education
				unless(education.nil?)
					education.each do |val|
										@eduArray.push("educationID" => val.id.to_s , "degree" => val.degree , "college" => val.college , "date" => val.date, "field" => val.field)
								   end
				end
			end					 
        end 
	end
	
	def editEducation
		@dataARY      								= 		Array.new
		@data 										= 		session[:userid] 
		@educationID								= 		params[:EduID]
		unless(params[:EduID].blank?)
			unless(@data.to_s.nil?)
				emp_data  							= 		Portfolio.find_by_ownerid(@data.to_s)
				unless(emp_data.nil?)
					education						= 		emp_data.education
					unless(education.nil?)
						education.each do |val|
											if(val.id.to_s == params[:EduID].to_s)
												@dataARY.push("degree" => val.degree , "college" => val.college , "date" => val.date, "field" => val.field)
											end	
										end	
					end
				end
			end	
		end
	end
	
	def updateEducation
		unless(params[:degree].nil?)
			certificate										=		params[:degree]
			university	 			  						= 		params[:university]
			date	 			  							= 		params[:date]
			field	 			  							= 		params[:field]
			educationID			  							= 		params[:educationID]
			@data 											= 		session[:userid] 
			
			unless(@data.to_s.nil?)
				emp_data  									= 		Portfolio.find_by_ownerid(@data.to_s)
				unless(emp_data.nil?)
					education								= 		emp_data.education
					unless(education.nil?)
						education.each do |val|
											if(val.id.to_s == educationID.to_s)
												val.college			=		university
												val.degree			=		certificate
												val.field			=		field
												val.date			=		date
												result  			= 		emp_data.save
												if(result == true)
													@text					=	"1"
													render :json => @text
												end
											end	
										end		
					end	
				end
			end		
		end	
	end	

	def myResumePopup
		unless(params[:add].nil?)
			resume											=		params[:upload][:file]
			resumename										=		resume.original_filename 
			directory 										= 		"public/resume"
			path 											= 		File.join(directory, resumename) 
			File.open(path, "wb+") do |f| 
									      f.write(resume.read)
								   end
			
			@data 											= 		session[:userid]
			unless(@data.to_s.nil?)
				emp_data  									= 		Portfolio.find_by_ownerid(@data.to_s)
				unless(emp_data.nil?)
					unless(resumename.nil?)
						cntins  							= 		Resume.new(:name => resumename)
						emp_data.resume << cntins
						emp_data.save
					
						if(cntins.save == true)
							@msg     						= 		"successfully inserted"
							
						end 
					end
				end	
			end	 
		end	 
	end
	
	def myResum
		
	end
		
	def myEducationPopup
	end
	
	def myEdu
		unless(params[:degree].nil?)
			certificate										=		params[:degree]
			university	 			  						= 		params[:university]
			date	 			  							= 		params[:date]
			field	 			  							= 		params[:field]
			@data 											= 		session[:userid] 
			
			unless(@data.to_s.nil?)
				emp_data  									= 		Portfolio.find_by_ownerid(@data.to_s)
				unless(emp_data.nil?)
					unless(certificate.nil?)
						cntins  							= 		Education.new(:degree => certificate, :college => university, :date => date, :field => field)
						emp_data.education << cntins
						emp_data.save
					
						if(cntins.save == true)
							@msg     						= 		"successfully inserted"
						end 
					end
				else
					portfolioData								=		Portfolio.new(:ownerid => @data.to_s)
					 if(portfolioData.save == true)	
						unless(certificate.nil?)
							cntins  							= 		Education.new(:degree => certificate, :college => university, :date => date, :field => field)
							emp_data.education << cntins
							emp_data.save
						
							if(cntins.save == true)
								@msg     						= 		"successfully inserted"
							end 
						end
					 end
				end	
			end	
			 @text					=	"1"
			render :json => @text
		end	
	end
	
	def popupApplyJob
		@jobID												=		params[:jobID]
		unless(params[:jobIDVal].nil?)
			jobID											=		params[:jobIDVal]
			describe 			  							= 		params[:desc]
			unless(jobID.nil?)
				data										=		Jobposting.find_by_id(jobID)
				unless(data.nil?)
					unless(describe.nil?)
						cntins  							= 		Rating.new(:jobseekerid => session[:userid].to_s, :rating => describe.to_s)
						data.rating << cntins
						data.save
					
						if(cntins.save == true)
							Jobposting.push({:id => jobID}, :jobSeeker => session[:userid].to_s)
							@msg     						= 		"successfully inserted"
							redirect_to :action 			=>		"myJobFinder"
						end 
					end
				end	
			end	
		end
	end
	
	def addMyRating
		unless(params[:jobIDVal].nil?)
			jobID											=		params[:jobIDVal]
			describe 			  							= 		params[:describe]
			unless(jobID.nil?)
				data										=		Jobposting.find_by_id(jobID.to_s)
				unless(data.nil?)
					unless(describe.nil?)
					data.update_attributes(:rating => [Rating.new(:jobseekerid => session[:userid].to_s, :rating => describe.to_s)])
					
							Jobposting.push({:id => jobID}, :jobSeeker => session[:userid].to_s)
							Prospect.push({:id => session[:userid].to_s}, :jobsapplied => jobID)
							@text					=	"1"
							render :json => @text
					end
				end	
			end	
		end
	end
	
	def myJobAssessment 
		@prerequisiteArray									=		Array.new	
		@requiredArray										=		Array.new
		@desiredArray										=		Array.new	
		@count												=		0
		@cont												=		0	
		@ct													=		0	
		@totalEmployeeScore									=		0	
		@skillData											=		Array.new
		@rate												=		Array.new	
		
					
		unless(params[:jobID].nil?)
			@jobID											=		params[:jobID] 
			data											=		Jobposting.find_by_id(params[:jobID].to_s)	
			unless(data.nil?)
				postingCompanyId							=		data.postingcompany
				postingCompanyQry							=		Employer.find_by_id(postingCompanyId.to_s)
				@companyName								=		postingCompanyQry.name
				@companyCity								=		postingCompanyQry.city
				@companyState								=		postingCompanyQry.state
				@jobDesc									=		data.description
				prerequisite								=		data.allowedcredentials
				required									=		data.requiredskills
				desired										=		data.desiredskills
				unless(prerequisite.blank?)
					prerequisite.each do |val|
										  @prerequisiteArray.push("prequisite" => (Prequisite.find_by_id(val.to_s).name), "prequisiteID" => val)
									  end	
				end
				userid 	= 		Portfolio.find_by_ownerid(session[:userid].to_s).id
				Portfolioitem.where(:portfolioid => userid.to_s).all.each do |valu|
																				portId				=		valu.id
																				skillQuery			=		Portfolioitemskill.find_by_portfolioitemid(portId.to_s)
																				unless(skillQuery.value.blank?)	
																					@skillData.push("skillID" => skillQuery.skillid, "value" => skillQuery.value) 
																				end
																		   end		
				unless(required.blank?)
					required.each do |val|
							@name								=		Skill.find_by_id(val).name
							skillQuery							=		Skillsrating.find_by_jobID(params[:jobID].to_s)
							@skillRating						=		skillQuery.skillrating
							
							if(@skillData.empty?)
								@skillRating.each do |value| 
												if(value.skillid.to_s == val.to_s)
													@proficency	= 		value.priority 
													@Impotance	= 		value.ranking.to_i
												end	
											end	
											
								@requiredArray.push("reqSkills" => @name, "reqSkillID" => val, "skillVal" => 0 ,  "employeeVal" => @proficency)																	
								@rate.push("prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)
							else
								if(h = @skillData.find { |h| h['skillID'] == val })
									h['value'].each do |vlue|
														@prof				=		vlue.proficency
												  end
									@skillRating.each do |value| 
												if(value.skillid.to_s == val.to_s)
													@proficency	= value.priority 
													@Impotance	= 		value.ranking.to_i
												end	
											end	
										
										
									@requiredArray.push("reqSkills" => @name, "reqSkillID" => val, "skillVal" => @prof,  "employeeVal" =>@proficency)																	
									@rate.push("prof" => @prof, "employerProf" => @proficency , "employerImp" => @Impotance)						  	
								else
									@skillRating.each do |value| 
												if(value.skillid.to_s == val.to_s)
													@proficency	= value.priority 
													@Impotance	= 		value.ranking.to_i
												end	
											end
											
									@requiredArray.push("reqSkills" => @name, "reqSkillID" => val, "skillVal" => 0,  "employeeVal" => @proficency)																	
									@rate.push("prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)
								end	
							end	
						end	
				end	
				
				unless(desired.blank?)
					desired.each do |val|
							@name								=		Skill.find_by_id(val).name
							skillQuery							=		Skillsrating.find_by_jobID(params[:jobID].to_s)
							@skillRating						=		skillQuery.skillrating
							
							if(@skillData.empty?)
								@skillRating.each do |value| 
												if(value.skillid.to_s == val.to_s)
													@proficency	= value.priority 
													@Impotance	= 		value.ranking.to_i
												end	
											end	
											
								@desiredArray.push("desSkills" => @name, "desSkillID" => val, "skillVal" => 0, "employeeVal" => @proficency)																	
								@rate.push("prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)
							else
								if(h = @skillData.find { |h| h['skillID'] == val })
									h['value'].each do |vlue|
														@prof				=		vlue.proficency
												  end
									@skillRating.each do |value| 
												if(value.skillid.to_s == val.to_s)
													@proficency	= value.priority 
													@Impotance	= 		value.ranking.to_i
												end	
											end	
										
									@desiredArray.push("desSkills" => @name, "desSkillID" => val, "skillVal" => @prof, "employeeVal" => @proficency)																	
									@rate.push("prof" => @prof, "employerProf" => @proficency , "employerImp" => @Impotance)						  	
								else
									@skillRating.each do |value| 
												if(value.skillid.to_s == val.to_s)
													@proficency	= value.priority 
													@Impotance	= 		value.ranking.to_i
												end	
											end	
									
									@desiredArray.push("desSkills" => @name, "desSkillID" => val, "skillVal" => 0, "employeeVal" => @proficency)
									@rate.push("prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)																	
								end	
							end	
						end	
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
							else
								@totalEmployeeScore	=	@totalEmployeeScore + 0
							end	
					   end
		end
	end
	
	def courseDetails
		@courseDetailsArray									=		Array.new		
		@cours 												=		params[:course].to_s				
		unless(params[:course].nil?)
			coursedetails									=		Skill.find_by_id(params[:course].to_s).course
			unless(coursedetails.nil?)
				coursedetails.each do |val|
										course					=		Course.find_by_id(val.to_s)
										instution				=		Institution.find_by_id(course.institutionid.to_s)	
										unless(instution.location.blank?)
											location			=		instution.location
										else
											location			=		instution.city + ' ' + instution.state
										end	
										unless(course.timerequired.blank?)
											time			=		course.timerequired
										else
											time			=		course.courseMeet
										end		
										@courseDetailsArray.push("InstitutionName" => instution.name, "InstitutionAddress1" => location, "InstitutionWebsite" => instution.website, "courseTitle" => course.title, "startdate" => course.startdate, "cost" => course.cost, "timerequired" => time  )
								   end
			end					   
		end
	end
	
	def distance 
		unless(params[:distance].nil?)
			$distArray 										=		Array.new
			$distArray 										= 		ActiveSupport::JSON.decode(params[:distance])
			@text								=	"1"
			render :json => @text
		end	
	end
	
	
	
	
	def myskillSmart  
	end
	
	def registerSuccess 
	end
	
	def  portfolio
		session[:userid]		=		$usid
		session[:name]			=		$fname
		session[:lastname]		=		$lname
	end
	
	def maps
		@zip 												= 		Array.new
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)	
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)	
		@zip.push(20190)
		@zip.push(20190)	
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)	
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)	
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)	
		@zip.push(20190)
		@zip.push(20190)	
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)	
		@zip.push(20190)	
		@zip.push(20190)
		@zip.push(20190)	
		@zip.push(20190)
		@zip.push(20190)
		@zip.push(20190)	
		@zip.push(20190)			
	end
	
	def myJobFinder
		@zip 												= 		Array.new
		@noDays												=		Array.new
		@cntArray											=		Array.new
		@cnt_data  											= 		Jobposting.sort(:created_at.desc).all
		@skillInfoData										= 		Skill.sort(:created_at.desc).all
		@skillQuery											=		Skillsrating.sort(:created_at.desc).all
		@ab													=		Array.new
		@ac													=		Array.new
		@skillAry											=		Array.new
		@skillData											=		Array.new	
		@rate												=		Array.new	
		@totalEmployeeScore									=		0	
		@totalSkillScore									=		0

		
		@distHash = Hash["Within 5mi" => 13, "Within 10mi" => 14, "Within 15mi" => 15, "Within 20mi" => 16, "Within 25mi" => 17]
		@cnt_data.each do |val|  
							@zip.push((Employer.find_by_id(val.postingcompany)).zip)
							@noDays.push((Date.today - val.created_at.to_date ).to_i)
					   end	
					   
		userid 		 = 		Portfolio.find_by_ownerid(session[:userid].to_s).id
		Portfolioitem.where(:portfolioid => userid.to_s).all.each do |valu|
							portId				=		valu.id
							skillQuery			=		Portfolioitemskill.find_by_portfolioitemid(portId.to_s)
							unless(skillQuery.value.blank?)	
								@skillData.push("skillID" => skillQuery.skillid, "value" => skillQuery.value) 
							end
					   end	
					   
		emp_data  														= 		Prospect.find_by_id(session[:userid].to_s)
		applied															=		emp_data.jobsapplied.uniq
		invited															=		emp_data.jobswatched.uniq
		applied.concat(invited) 
		applied.uniq	
			
		unless(@cnt_data.nil?)
				@cnt_data.zip(@noDays).each do |val, vale|  
													company				=		val.postingcompany
													comp				=		Employer.find_by_id(company.to_s)
													name				=		comp.name
													loc					=		comp.city + ',' + comp.state + ',' + comp.zip.to_s	
													companytype			=		comp.companytype

													
													
												
													data				=		session[:userid].to_s
													reqSkills			=		val.requiredskills
													desSkills			=		val.desiredskills
													
													
													@skillQuery.each do |data|
																		  if(data.jobID.to_s == val.id.to_s)
																			  @skillRating			=		data.skillrating
																		  end
																	 end
																								
													unless(data.blank?)
														unless(reqSkills.blank?)
															reqSkills.each do |value|
																				if(@skillAry.length <5)
																					@skillInfoData.each do |info|
																											if(info.id.to_s == value.to_s)
																												@skillAry.push(info.name)
																											end
																										end
																				end	
																				#@skillName										    = 		@skillAry.join(',')
																				@skillRating.each do |vals| 
																									if(vals.skillid.to_s == value.to_s)
																										@proficency					= 		vals.priority.to_i 
																										@Impotance					= 		vals.ranking.to_i 
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
																				@skillRating.each do |vals| 
																									if(vals.skillid.to_s == value.to_s)
																										@proficency						= 		vals.priority.to_i 
																										@Impotance						= 		vals.ranking.to_i 
																									end	
																								end		
																					
																				
																				if(@skillData.empty?)
																					@rate.push("prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)																	
																				else
																					if(h = @skillData.find { |h| h['skillID'] == value })
																						h['value'].each do |vlue|
																												@prof					=		vlue.proficency.to_i
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
														
														@rate.clear	
														reqSkills.clear
														desSkills.clear
														
													end	
													if(@totalEmployeeScore > 0)
														if(@totalSkillScore.to_f > 100)
															normal					=		@totalSkillScore.to_f/100
															@totalSkillScore		=		@totalSkillScore.to_f/normal.to_f
															@totalEmployeeScore		=		@totalEmployeeScore.to_f/normal.to_f
														else
															normal					=		100/@totalSkillScore.to_f
															@totalSkillScore		=		@totalSkillScore.to_f*normal.to_f
															@totalEmployeeScore		=		@totalEmployeeScore.to_f*normal.to_f	
														end	
														if(applied.include? val.id.to_s)
															@cntArray.push( "scoreJob" => @totalEmployeeScore.to_f  , "jobScore" => @totalSkillScore , "noOpen" => val.numpositions , "JobDesc" => val.description,  "noDays" => vale , "jobID" => val.id,  "compName" => name, "jobDetails" => val.details, "skillName1" => @skillAry[0], "skillName2" => @skillAry[1] , "skillName3" => @skillAry[2] , "skillName4" => @skillAry[3] , "skillName5" => @skillAry[4] , "location" => loc , "display" => "0")	
														else
															@cntArray.push( "scoreJob" => @totalEmployeeScore.to_f  , "jobScore" => @totalSkillScore ,  "noOpen" => val.numpositions , "JobDesc" => val.description,  "noDays" => vale , "jobID" => val.id,  "compName" => name, "jobDetails" => val.details, "skillName1" => @skillAry[0], "skillName2" => @skillAry[1] , "skillName3" => @skillAry[2] , "skillName4" => @skillAry[3] , "skillName5" => @skillAry[4] , "location" => loc , "display" => "1")															
														end
													end	
													@totalEmployeeScore			=				0
													@totalSkillScore			=				0
													@skillName					=				nil
													@skillAry.clear
											end	
			unless(@cntArray.blank?)
					@cntArray.sort_by! {|e| -e["scoreJob"] }
			end											
		end	
	end
	
	def applyJob
		unless(params[:jobID].nil?)
			unless(params[:candidateID].nil?)
				Jobposting.push({:id => params[:jobID]}, :jobSeeker => session[:userid].to_s)
				Prospect.push({:id => params[:candidateID].to_s}, :jobsapplied => params[:jobID])
				@text								=	"1"
				render :json => @text
			end	
		end	
	end
	
	
	def editMyProfile
		@dataARY      								= 		Array.new
		unless(session[:userid].to_s.blank?)
			data									=		Prospect.find_by_id(session[:userid].to_s.to_s)
			@dataARY.push("firstname" => data.employeefirstname, "lastname" => data.employeelastname, "address" => data.employeeaddress, "city" => data.city, "state" => data.state, "country" => data.country, "zip" => data.zip , "mobile" => data.employeemobile, "username" => data.employeeusername , "twitter" => data.twitter, "linkedin" => data.linkedin)
		end
	end
	
	def myProfile
		@dataARY      								= 		Array.new
		unless(session[:userid].to_s.blank?)
			data									=		Prospect.find_by_id(session[:userid].to_s.to_s)
			@dataARY.push("firstname" => data.employeefirstname, "lastname" => data.employeelastname, "address" => data.employeeaddress, "city" => data.city, "state" => data.state, "country" => data.country, "zip" => data.zip, "mobile" => data.employeemobile)
		end
	end
	
	def updateMyProfile
		unless(params[:cancel].nil?)
            redirect_to :action 					=>		"portfolioNew"
        end	
		unless(params[:update].nil?)
			fname	 			  					= 		params[:fname]
			lname	 			  					= 		params[:lname]
			address		  							= 		params[:addressline1]
			city			  						= 		params[:city]
			state	 			  					= 		params[:state]
			country	 			  					= 		params[:country]
			zip		 			  					= 		params[:zip]
			mobile	 			  					= 		params[:mobile]
			twitter	 			  					= 		params[:twitter]
			linkedin 			  					= 		params[:linkedin]
			
			unless(fname.nil?)
				employ								=		Prospect.find_by_id(session[:userid].to_s)
				unless(employ.nil?)
					employ.employeefirstname 		= 		fname
					employ.employeelastname			= 		lname
					employ.employeeaddress 			= 		address
					employ.city		 				= 		city
					employ.state					= 		state
					employ.country	 				= 		country
					employ.zip		 				= 		zip
					employ.employeemobile			= 		mobile
					employ.twitter	 				= 		twitter
					employ.linkedin					= 		linkedin					

					result  = employ.save
					if(result == true)
						@msg     					= 		"successfully inserted"
						redirect_to :action 		=>		"portfolioNew"
					end
				end	
			end
		end	
	end	
	
	def dashboard
		@cntArray      							= 		Array.new
		@data 									= 		session[:userid] 
		@count									=		0
		@watchArray    							= 		Array.new
		@cnt									=		0
		
		unless(@data.to_s.nil?)
			emp_data  							= 		Prospect.find_by_id(@data.to_s)
			unless(emp_data.nil?)       
				applied							=		emp_data.jobsapplied
				invited							=		emp_data.invited
				applied							= 		applied.uniq
				invited							= 		invited.uniq
				watched							=		emp_data.jobswatched
				watched							= 		watched.uniq
				
				unless(applied.blank?)
					applied.each do |val|
									 jobData	=		Jobposting.find_by_id(val.to_s)
									 if(invited.include?(val))
										@status	=		"Invited"
									 else
										@status	=		"Not Invited yet"
									 end
									 @cntArray.push("job" => (jobData.description), "jobID" => jobData.id , "company" => (Employer.find_by_id(jobData.postingcompany).name) , "status" => @status, "closed" => "Open")
							     end
				end
				unless(watched.blank?)
					watched.each do |val|
									 jobData	=		Jobposting.find_by_id(val.to_s)
									 @watchArray.push("job" => (jobData.description) ,  "jobID" => jobData.id , "company" => (Employer.find_by_id(jobData.postingcompany).name))
								end
				end	
			end					 
        end
	end
	
	def demo
		@i 													= 		0 
		@zip 												= 		Array.new
		@minlimit											=		0
		@maxlimit											=		0
		@noDays												=		Array.new
		@cntArray											=		Array.new
		@cnt_data  											= 		Jobposting.sort(:created_at).all
		@ab													=		Array.new
		@ac													=		Array.new
		@skillAry											=		Array.new
		@skillData											=		Array.new	
		@rate												=		Array.new	
		@totalEmployeeScore									=		0	
		
		@cnt_data.each do |val|  
							@zip.push((Employer.find_by_id(val.postingcompany)).zip)
							@noDays.push((Date.today - val.created_at.to_date ).to_i)
					   end		
		unless(@cnt_data.nil?)
			unless($distArray.blank?)
				@cnt_data.zip($distArray, @noDays).each do |val, vale, value|  
														company		=		val.postingcompany
														comp		=		Employer.find_by_id(company.to_s)
														name		=		comp.name
														loc			=		comp.city + ' ' + comp.state	
														companytype	=		comp.companytype
														skills		=		val.requiredskills
														skills.each do |data|
																		@skillAry.push(Skill.find_by_id(data.to_s).name)
																	end	
														skillName    = 		@skillAry.join(',')			
														@cntArray.push("copmanyPost" => val.numpositions , "noOpen" => val.numpositions , "JobDesc" => val.description, "distance" => vale , "noDays" => value , "salary" => val.salary, "jobID" => val.id, "type" => companytype, "compName" => name, "jobDetails" => val.details, "skillName" => skillName, "location" => loc)	
												   end
			else
				@cnt_data.zip(@noDays).each do |val, value| 
												company		=		val.postingcompany
												comp		=		Employer.find_by_id(company.to_s)
												name		=		comp.name
												loc			=		comp.city + ' ' + comp.state
												companytype	=		comp.companytype
												@cntArray.push("copmanyPost" => val.numpositions , "noOpen" => val.numpositions , "JobDesc" => val.description,  "noDays" => value , "salary" => val.salary, "jobID" => val.id, "type" => companytype, "compName" => name, "jobDetails" => val.details, "location" => loc)	
										   end
																
			end	
		end		
	end
	
	def filter
		unless(params[:filter].nil?)
			@i 													= 		0 
			@zip 												= 		Array.new
			@minlimit											=		0
			@maxlimit											=		0
			@noDays												=		Array.new
			@cntArray											=		Array.new
			$dataArray											=		Array.new
			@cnt_data  											= 		Jobposting.sort(:created_at.desc).all
			@skillInfoData										= 		Skill.sort(:created_at.desc).all
			@skillQuery											=		Skillsrating.sort(:created_at.desc).all
			@ab													=		Array.new
			@ac													=		Array.new
			@skillAry											=		Array.new
			@skillData											=		Array.new	
			@rate												=		Array.new	
			@totalEmployeeScore									=		0
			
			@cnt_data.each do |val|  
								@zip.push((Employer.find_by_id(val.postingcompany)).zip)
								@noDays.push((Date.today - val.created_at.to_date ).to_i)
						   end		
			userid 		 = 		Portfolio.find_by_ownerid(session[:userid].to_s).id
			Portfolioitem.where(:portfolioid => userid.to_s).all.each do |valu|
								portId				=		valu.id
								skillQuery			=		Portfolioitemskill.find_by_portfolioitemid(portId.to_s)
								unless(skillQuery.value.blank?)	
									@skillData.push("skillID" => skillQuery.skillid, "value" => skillQuery.value) 
								end
						   end	
					   
			   		   	
			
			unless(@cnt_data.nil?)
				@cnt_data.zip($distArray, @noDays).each do |val, vale, va|  
															company				=		val.postingcompany
															comp				=		Employer.find_by_id(company.to_s)
															name				=		comp.name
															loc					=		comp.city + ',' + comp.state + ',' + comp.zip.to_s	
															companytype			=		comp.companytype

															
															
														
															data				=		session[:userid].to_s
															reqSkills			=		val.requiredskills
															desSkills			=		val.desiredskills
															
															
															@skillQuery.each do |data|
																				  if(data.jobID.to_s == val.id.to_s)
																					  @skillRating			=		data.skillrating
																				  end
																			 end
																										
															unless(data.blank?)
																unless(reqSkills.blank?)
																	reqSkills.each do |value|
																						if(@skillAry.length <5)
																							@skillInfoData.each do |info|
																													if(info.id.to_s == value.to_s)
																														@skillAry.push(info.name)
																													end
																												end
																						end	
																						#@skillName										    = 		@skillAry.join(',')
																						@skillRating.each do |vals| 
																											if(vals.skillid.to_s == value.to_s)
																												@proficency					= 		vals.priority.to_i 
																												@Impotance					= 		vals.ranking.to_i 
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
																						@skillRating.each do |vals| 
																											if(vals.skillid.to_s == value.to_s)
																												@proficency						= 		vals.priority.to_i 
																												@Impotance						= 		vals.ranking.to_i 
																											end	
																										end		
																							
																						
																						if(@skillData.empty?)
																							@rate.push("prof" => 0, "employerProf" => @proficency , "employerImp" => @Impotance)																	
																						else
																							if(h = @skillData.find { |h| h['skillID'] == value })
																								h['value'].each do |vlue|
																														@prof					=		vlue.proficency.to_i
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
																				else
																					@totalEmployeeScore	=	@totalEmployeeScore + 0
																				end	
																		   end	
																
																@rate.clear	
																reqSkills.clear
																desSkills.clear
																
															end	
															if(@totalEmployeeScore > 0)
																@cntArray.push( "distance" => vale , "copmanyPost" => val.numpositions , "scoreJob" => @totalEmployeeScore  , "noOpen" => val.numpositions , "JobDesc" => val.description,  "noDays" => va  , "salary" => val.salary, "jobID" => val.id, "type" => companytype,  "compName" => name, "jobDetails" => val.details, "skillName1" => @skillAry[0], "skillName2" => @skillAry[1] , "skillName3" => @skillAry[2] , "skillName4" => @skillAry[3] , "skillName5" => @skillAry[4] , "location" => loc )	
															end	
															@totalEmployeeScore			=				0
															@skillName					=				nil
															@skillAry.clear
														end
				 unless(@cntArray.blank?)
					@cntArray.sort_by! {|e| -e["scoreJob"] }
				end															
			end	
				
			unless(params[:filter].nil?)
				if(params[:filter].include? "1")
					@minlimit									=				19999.to_f
					@maxlimit									=				39999.to_f
					@cntArray.each do |item| 
										if((item['salary'].to_f  > @minlimit) && (item['salary'].to_f  < @maxlimit) )
											@ab.push(item)
										end
									end
				end					
				if(params[:filter].include? "2")
					@minlimit									=				39999.to_f
					@maxlimit									=				59999.to_f
					@cntArray.each do |item| 
										if((item['salary'].to_f  > @minlimit) && (item['salary'].to_f  < @maxlimit) )
											@ab.push(item)
										end
									end
				end					
				if(params[:filter].include? "3")
					@minlimit									=				59999.to_f
					@maxlimit									=				79999.to_f
					@cntArray.each do |item| 
										if((item['salary'].to_f  > @minlimit) && (item['salary'].to_f  < @maxlimit) )
											@ab.push(item)
										end
									end
				end					
				if(params[:filter].include? "4")
					@minlimit									=				79999.to_f
					@maxlimit									=				99999.to_f
					@cntArray.each do |item| 
										if((item['salary'].to_f  > @minlimit) && (item['salary'].to_f  < @maxlimit) )
											@ab.push(item)
										end
									end
				end					
				if(params[:filter].include? "5")
					@minlimit									=				99999.to_i
					@maxlimit									=				119999.to_i
					@cntArray.each do |item| 
										if((item['salary'].to_f  > @minlimit) && (item['salary'].to_f  < @maxlimit) )
											@ab.push(item)
										end
									end
				end	
				if(params[:filter].include? "6")
					@minlimit									=				119999.to_i
					@maxlimit									=				149999.to_i
					@cntArray.each do |item| 
										if((item['salary'].to_f  > @minlimit) && (item['salary'].to_f  < @maxlimit) )
											@ab.push(item)
										end
									end
				end	
				if(params[:filter].include? "7")
					@minlimit									=				149999.to_i
					@maxlimit									=				11999999.to_i
					@cntArray.each do |item| 
										if((item['salary'].to_f  > @minlimit) && (item['salary'].to_f  < @maxlimit) )
											@ab.push(item)
										end
									end
				end	
				
				unless(@ab.blank?)
					@ab.each do |item| 
								@ac.push(item)	
							end
					@ab.clear
				end	
						
				if((params[:filter].include? "8") || (params[:filter].include? "9") || (params[:filter].include? "10" ) || (params[:filter].include? "11") || (params[:filter].include? "12"))		
					unless(@ac.blank?)	
						if(params[:filter].include? "8")
							@maxlimit										=				"5215f5bbf1bb55071c000554"
							@ac.each do |item| 
												if((item['type'].to_s  == @maxlimit.to_s))
													@ab.push(item)
												end
											end
						end					
						if(params[:filter].include? "9")
							@maxlimit										=				"5215fd74f1bb55071c00055f"
							@ac.each do |item| 
												if((item['type'].to_s  == @maxlimit.to_s))
													@ab.push(item)
												end
											end	
						end					
						if(params[:filter].include? "10")
							@maxlimit										=				"5215fd8df1bb55071c000570"
							@ac.each do |item| 
												if((item['type'].to_s  == @maxlimit.to_s))
													@ab.push(item)
												end
											end
						end					
						if(params[:filter].include? "11")
							@maxlimit										=				"5215fda5f1bb55071c000589"
							@ac.each do |item| 
												if((item['type'].to_s  == @maxlimit.to_s))
													@ab.push(item)
												end
											end
						end					
						if(params[:filter].include? "12")
							@maxlimit										=				"5215fdc6f1bb55071c0005aa"
							@ac.each do |item| 
												if((item['type'].to_s  == @maxlimit.to_s))
													@ab.push(item)
												end
											end
						end
						unless(@ab.blank?)
							@ac.clear
							@ab.each do |item| 
										@ac.push(item)	
									 end
							@ab.clear	
							
						end	
					end	
				end
				if((params[:filter].include? "13") || (params[:filter].include? "14") || (params[:filter].include? "15") || (params[:filter].include? "16") || (params[:filter].include? "17"))		
					unless(@ac.blank?)	
						
					
					if(params[:filter].include? "13")
						@limit										=				5.to_f
					elsif(params[:filter].include? "14")
						@limit										=				10.to_f	
					elsif(params[:filter].include? "15")
						@limit										=				15.to_f
					elsif(params[:filter].include? "16")
						@limit										=				20.to_f
					elsif(params[:filter].include? "17")
						@limit										=				25.to_f
					end	
					
					unless(@limit.blank?)
						@ac.each do |item| 
											if((item['distance'].to_f  < @limit))
												@ab.push(item)
											end
										end
						@cntArray.clear
						@ab.each do |item| 
									@cntArray.push(item)	
								 end
						@ab.clear						
					end	
					
				end							
			end
			
			@ab.clear
			@cntArray.each do |val|
								if(val["scoreJob"] > 0)
									@ab.push(val);
								end	
							end
			 unless(@ab.blank?)
				@ab.sort_by! {|e| -e["scoreJob"] }
			end	
			totJob				=			@ab.length
									
			render :json => {
								:listJobs => @ab ,
								:totJob	  => totJob	
							}
			end				
		end	
	end	
	
end
