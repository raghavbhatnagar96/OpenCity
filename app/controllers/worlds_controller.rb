class WorldsController < ApplicationController
  before_action :set_world, only:[:show, :edit, :update, :destroy]
  before_action :set_world_role, only:[:world_settings, :admin_world_settings, :add_remove_role, :add_role, :remove_role]
  layout "world_admin", :only => [:admin_world_settings, :add_remove_role, :add_role]

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
  end

  # view only my worlds NEED to be optimized
  def my_worlds
    @user = current_user
    @worlds = World.all
    # puts @worlds
    myWorld = World.where(:title => @user[:email])
    worldID = myWorld[0].id
    # puts worldID
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
    data2 = {"admin"=> "ALL"}
    @world.privilege_table = data2.to_json
    email = @user[:email]
    respond_to do |format|
      if @world.save 
        invoke("Create World: " + @world.title, email, "admin", worldID)
        format.html { redirect_to @world, notice: 'World was successfully created.' }
        format.json { render :show, status: :created, location: @world }
      else
        format.html { render :new }
        format.json { render json: @world.errors, status: :unprocessable_entity }
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
  end


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
