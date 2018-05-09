class WorldsController < ApplicationController
  before_action :set_world, only:[:show, :edit, :update, :destroy]
  before_action :set_world_role, only:[:world_settings, :admin_world_settings, :add_remove_role, :add_role, :remove_role, :change_privilege, :add_remove_world, :add_world, :remove_world, :change_world_role, :change_location_landing, :change_location]
  layout "world_admin", :only => [:admin_world_settings, :add_remove_role, :add_remove_world, :change_location_landing]

  #use set_world_role before all actions where role of user in world is important
  
  # GET /worlds
  # GET /worlds.json
  def index
    @user = current_user
    @worlds = World.all
  end

  # GET /worlds/1
  # GET /worlds/1.json
  # how to parse json please refer to this
  def show
    @user = current_user
    @data = JSON(@world.role_table)
    @data.each do |user_id, role|
      puts user_id
      puts role
    end
  end

  # GET /worlds/new
  def new
    @user = current_user
    @world = World.new
  end

  # GET /worlds/1/edit
  def edit
    @user = current_user
    set_world_role
    if(@my_role != "admin")
      redirect_to root_path
    end
    if(@world.title==@user.email)
      redirect_to my_worlds_path
    end
  end

  # view only my worlds NEED to be optimized
  def my_worlds
    @user = current_user
    @worlds = World.all
    myWorld = World.where(:title => @user[:email])
    @myworldID = myWorld[0].id.to_i
    @myWorlds = []
    @worlds.each do |world|
      data = JSON(world.role_table)
      data.each do |world_id, role|
        if world_id.to_i == @myworldID
          @myWorlds.append(world)
        end
      end
    end
  end


  # POST /worlds
  # POST /worlds.json
  def create
    @user = current_user
    @world = World.new(world_params)
    # puts @user[:email]
    #takes @myWorld as a list of all worlds satisfying where clause
    # puts @myWorld[0].title
    @myWorld = World.where(:title => @user[:email])
    worldID = @myWorld[0].id 
    data = {worldID=> "admin"}
    @world.role_table = data.to_json
    @world.location_id = worldID
    data2 = {"admin"=> "ALL"}
    titles = World.where(:title => world_params[:title])
    # puts titles[0].title

    #unique name
    if !titles.empty?
      flash[:notice] = 'Try A different World Name'
      redirect_to new_world_path
    else
      @world.privilege_table = data2.to_json
      email = @user[:email]
      respond_to do |format|
        if @world.save 
          invoke("Create World: " + @world.title, email, "admin", worldID.to_s.to_s)
          format.html { redirect_to @world, notice: 'World was successfully created.' }
          format.json { render :show, status: :created, location: @world }
        else
          format.html { render :new }
          format.json { render json: @world.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /worlds/1
  # PATCH/PUT /worlds/1.json
  def update
    @user = current_user
    respond_to do |format|
      if @world.update(world_params)
        format.html { redirect_to @world, notice: 'World was successfully updated.' }
        format.json { render :show, status: :ok, location: @world }
      else
        format.html { render :edit }
        format.json { render json: @world.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_location_landing
    @user = current_user
    if(@my_role != "admin")
      redirect_to root_path
    end
    @worlds = World.all
    myWorld = World.where(:title => @user[:email])
    worldID = myWorld[0].id
    @myWorlds = []
    @worlds.each do |world|
      data = JSON(world.role_table)
      data.each do |world_id, role|
        if world_id.to_i == worldID.to_i && role == "admin"
          @myWorlds.append(world.title)
        end
      end
    end
  end

  def change_location
    @user = current_user
    if(@my_role != "admin")
      redirect_to root_path
    end
    oldLocation = @world.location_id
    newLocation = World.where(:title => params[:world_title])
    newLocation = newLocation[0]
    if @world.update(:location_id => newLocation.id)
      invoke("Changed location of "+@world.title+" from " +oldLocation.to_s+ " to "+newLocation.id.to_s, @user.email, "admin", @world.id.to_s)
      redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
    else
      redirect_to admin_world_settings_path, notice: 'Role was Not added successfully.', id: @world.id
    end
  end

  # DELETE /worlds/1
  # DELETE /worlds/1.json
  def destroy
    @user = current_user
    @world.destroy
    respond_to do |format|
      format.html { redirect_to worlds_url, notice: 'World was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


#functions for adding/removing worlds to role table

  def add_remove_world
    @user = current_user
    if(@my_role != "admin")
      redirect_to root_path
    end
    worlds = World.all
    @world_titles = []
    @world_titles2 = []
    data = JSON(@world.role_table)
    # puts data["2"]
    worlds.each do |thisWorld|
      if !data[thisWorld.id.to_s]
        @world_titles.append(thisWorld.title)
      else
        @world_titles2.append(thisWorld.title)
      end
    @world_titles.delete(@world.title)  
    end
    p_table = JSON(@world.privilege_table)
    @privileges = ["ALL", "WRITE", "EDIT", "READ"]
    @roles = []
    p_table.each do |role, privilege|
        @roles.append(role)
    end
  end

  def add_world
    @user = current_user
    if(@my_role != "admin")
      redirect_to root_path
    end
    r_table = JSON(@world.role_table)
    newWorld = World.where(:title => params[:world_title])
    newWorld = newWorld[0] 
    r_table[newWorld.id.to_s] = params[:role]
    if @world.update(:role_table => r_table.to_json)
      invoke("Added world to Role Table: " + newWorld.id.to_s, @user.email, "admin", @world.id.to_s)
      redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
    else
      redirect_to admin_world_settings_path, notice: 'Role was Not added successfully.', id: @world.id
    end
  end

  def remove_world
    @user = current_user
    if(@my_role != "admin")
      redirect_to root_path
    end
    r_table = JSON(@world.role_table)
    newWorld = World.where(:title => params[:world_title])
    newWorld = newWorld[0]
    adminCount = 0
    r_table.each do |eachworld, role|
        if role == "admin"
          adminCount = adminCount+1
        end
    end 
    if r_table[newWorld.id.to_s]!="admin"
      r_table.delete(newWorld.id.to_s)
      if @world.update(:role_table => r_table.to_json)
        invoke("Removed world from Role Table: " + newWorld.id.to_s, @user.email, "admin", @world.id.to_s)
        redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
      else
        redirect_to admin_world_settings_path, notice: 'Role was Not added successfully.', id: @world.id
      end

    #only remove admin if one admin is left
    elsif adminCount > 1
      r_table.delete(newWorld.id.to_s)
      if @world.update(:role_table => r_table.to_json)
        invoke("Removed world from Role Table: " + newWorld.id.to_s, @user.email, "admin", @world.id.to_s)
        redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
      else
        redirect_to admin_world_settings_path, notice: 'Role was Not added successfully.', id: @world.id
      end
    else
      redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
    end
  end

  def change_world_role
    @user = current_user
    if(@my_role != "admin")
      redirect_to root_path
    end
    r_table = JSON(@world.role_table)
    newWorld = World.where(:title => params[:world_title])
    newWorld = newWorld[0]
    adminCount = 0
    r_table.each do |eachworld, role|
        if role == "admin"
          adminCount = adminCount+1
        end
    end
    if r_table[newWorld.id.to_s]!="admin"
      r_table[newWorld.id.to_s] = params[:role]
      if @world.update(:role_table => r_table.to_json)
        invoke("Change world: " + newWorld.id.to_s + " role to: " + params[:role], @user.email, "admin", @world.id.to_s)
        redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
      else
        redirect_to admin_world_settings_path, notice: 'Role was Not added successfully.', id: @world.id
      end
    elsif adminCount > 1
      r_table[newWorld.id.to_s] = params[:role]
      if @world.update(:role_table => r_table.to_json)
        invoke("Change world: " + newWorld.id.to_s + " role to: " + params[:role], @user.email, "admin", @world.id.to_s)
        redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
      else
        redirect_to admin_world_settings_path, notice: 'Role was Not added successfully.', id: @world.id
      end
    else
      redirect_to admin_world_settings_path, notice: 'Role was Not added successfully.', id: @world.id
    end

  end

#End role_table altering functions







#functions for adding/removing roles and changing privilege of roles
 
  def add_remove_role
    @user = current_user
    if(@my_role != "admin")
      redirect_to root_path
    end
    worlds = World.all
    @world_titles = []
    data = JSON(@world.role_table)
    # puts data["2"]
    worlds.each do |thisWorld|
      if !data[thisWorld.id.to_s]
        @world_titles.append(thisWorld.title)
      end
    end
    p_table = JSON(@world.privilege_table)
    @privileges = ["ALL", "WRITE", "EDIT", "READ"]
    @roles = []
    p_table.each do |role, privilege|
        @roles.append(role)
    end
    # puts @roles
  end

  def add_role
    @user = current_user
    if(@my_role != "admin")
      redirect_to root_path
    end
    data = JSON(@world.privilege_table)
    data[params[:role]] = params[:privilege]
    if @world.update(:privilege_table => data.to_json)
      invoke("Added role: " + params[:role] + " with privilege: " + params[:privilege], @user.email, "admin", @world.id.to_s)
      redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
    else
      redirect_to admin_world_settings_path, notice: 'Role was Not added successfully.', id: @world.id
    end
  end

  def change_privilege
    @user = current_user
    if(@my_role != "admin")
      redirect_to root_path
    end
    data = JSON(@world.privilege_table)
    data[params[:role]] = params[:privilege]
    if @world.update(:privilege_table => data.to_json)
      invoke("Change privilege of role: " + params[:role] + "to " + params[:privilege], @user.email, "admin", @world.id.to_s)
      redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
    else
      redirect_to admin_world_settings_path, notice: 'Role was Not added successfully.', id: @world.id
    end
  end

  def remove_role
    @user = current_user
    if(@my_role != "admin")
      redirect_to root_path
    end
    if(params[:role]=="admin")
      redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
    end
    r_table = JSON(@world.role_table)
    data = JSON(@world.privilege_table)
    data.delete(params[:role])
    r_table.each do |eachworld, role|
        if role == params[:role]
          r_table[eachworld] = params[:change_to]
        end
    end  
    if @world.update(:privilege_table => data.to_json, :role_table => r_table.to_json)
      invoke("Remove role: " + params[:role] + " change to: " + params[:change_to], @user.email, "admin", @world.id.to_s)
      redirect_to controller: 'worlds', action: 'admin_world_settings', id: @world.id
    else
      redirect_to admin_world_settings_path, notice: 'Role was Not added successfully.', id: @world.id
    end
  end

#End of Role Altering functions






  #World Settings for non admin
  def world_settings
    @user=current_user
    # set_world_role
    puts @my_role
    if(@my_role == "admin")
      redirect_to admin_world_settings_path(request.parameters)  
    else
      # Normal User thingie
    end
  end


  #world Admin Settings
  def admin_world_settings
    @user=current_user
    # p_table.each do |role, privilege|
    #     @roles.append(role)
    # end
    if(@my_role != "admin")
      redirect_to root_path
    end
    @p_table = JSON(@world.privilege_table)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_world
      @world = World.find(params[:id])
    end

    #used to get role of user in world
    def set_world_role
      @user=current_user
      myWorld = World.where(:title => @user[:email])
      myWorld = myWorld[0]
      @world = World.find(params[:id])
      data = JSON(@world.role_table)
      @my_role = data[myWorld.id.to_s]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def world_params
      params.require(:world).permit(:title)
    end
end
