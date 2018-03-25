class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :first_user, :except => [:createUOD, :create_UOD]
  before_action :authenticate_user!, :except => [:createUOD, :create_UOD]

  def createUOD
   @world = World.new()
  end


  def create_UOD
    @world = World.new(UOD_params)
    respond_to do |format|
      if @world.save
        format.html { redirect_to :root, notice: 'World was successfully created.' }
        format.json { render :show, status: :created, location: @world }
      else
        format.html { render :new }
        format.json { render json: :root.errors, status: :unprocessable_entity }
      end
    end
  end


  private
  def first_user
  	unless World.exists?
  		redirect_to home_createUOD_url
  	end
  end

  

  def UOD_params
  	params.require(:world).permit(:title)
  end
   

end
