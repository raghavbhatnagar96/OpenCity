class HomeController < ApplicationController

#to view worlds and resources on home page	
	def index
		@user = current_user
		@worlds = World.all
	    # puts @worlds
	    myWorld = World.where(:title => @user[:email])
    	worldID = myWorld[0].id
	    @myWorlds = []
	    @worlds.each do |world|
	      # puts world
	      data = JSON(world.role_table)
	      # puts data
	      data.each do |world_id, role|
	        if world_id.to_i == worldID.to_i
	          @myWorlds.append(world)
	        end
	      end
	    end
	    @no_resource = "You have not added any resources yet"
	    # unless Resource.exists?
	    #   @noResource = "You have not added any resources yet"
	    # end
	    @resource_data = Resource.where(:user_id => @user[:id])	
	end

	def view_logs
		@user = current_user
		uod = World.find(1)
		myWorld = World.where(:title => @user[:email])
		myWorld = myWorld[0]
	    data = JSON(uod.role_table)
	    my_role = data[myWorld.id.to_s]
	    if my_role == "admin"
	    	puts "1"
	    else
	    	redirect_to root_path
	    end

	  end


end
