class WorldsController < ApplicationController
  before_action :set_world, only:[:show, :edit, :update, :destroy]

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


  #World Settings
  def world_settings
    @user=current_user
    myWorld = World.where(:title => @user[:email])
    myWorld = myWorld[0]
    @world = World.find(params[:id])
    data = JSON(@world.role_table)
    # puts myWorld.id-1
    puts data[myWorld.id.to_s]
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_world
      @world = World.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def world_params
      params.require(:world).permit(:title)
    end
end
