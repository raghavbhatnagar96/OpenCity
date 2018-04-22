class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :edit, :update, :destroy]
  #the above came as a default of using scaffolding. 
  #But it can't be used, as set_resource extracts resource based on id, but the number of resources might be 0
  #If that's the case, then an error will be thrown if this is used.

  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.all
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
  end

  # GET /resources/new
  def new
    @user = current_user
    @resource = Resource.new
  end

  # GET /resources/1/edit
  def edit
  end

  # POST /resources
  # POST /resources.json
  def create
    @user = current_user
    @resource = Resource.new(resource_params)
    @myWorld = World.where(:title => @user[:email])
    worldID = @myWorld[0].id
    @resource.user_id = @user.id
    @resource.date_published = Date.today
    respond_to do |format|
      if @resource.save
        invoke("Resource created: " + @resource.title, @user[:email], "admin", worldID)
        # puts("Resource created: " + @resource.title, @user[:email], "admin", worldID)
        format.html { redirect_to :root, notice: 'Resource was successfully created.' }
        format.json { render :show, status: :created, location: @resource }
      else
        format.html { render :new }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resources/1
  # PATCH/PUT /resources/1.json
  def update
    respond_to do |format|
      if @resource.update(resource_params)
        @myWorld = World.where(:title => @user[:email])
        worldID = @myWorld[0].id
        invoke("Resource destroyed: " + @resource.title, @user[:email], "admin", worldID)
        format.html { redirect_to :root, notice: 'Resource was successfully updated.' }
        format.json { render :show, status: :ok, location: @resource }
      else
        format.html { render :edit }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource.destroy
    @myWorld = World.where(:title => @user[:email])
    worldID = @myWorld[0].id
    invoke("Resource destroyed: " + @resource.title, @user[:email], "admin", worldID)
    respond_to do |format|
      format.html { redirect_to resources_url, notice: 'Resource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def user_resources
    unless Resource.exists?
      redirect_to resources_upload_resource_path
    end
    @user = current_user
    @data = Resource.where(:user_id => @user[:id])
  end

  def view_resource
    @user = current_user
    @resource = Resource.find(params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @user = current_user
      @resource = Resource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def resource_params
        params.require(:resource).permit(:description, :title, :date_published, :uploads)

    end
end
