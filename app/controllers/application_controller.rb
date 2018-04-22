class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :first_user, :except => [:createUOD, :create_UOD]
  before_action :authenticate_user!, :except => [:createUOD, :create_UOD]
  layout "auth", :only => [:createUOD, :create_UOD]

  def create_UOD
    unless World.exists?
      @world = World.new()
      data = {2 => "admin"}
      @world.role_table=data.to_json
      data1 = {"admin" => "ALL"}
      @world.privilege_table = data1.to_json
      @world1 = params[:world]
      @world[:title] = @world1[:title]
      respond_to do |format|
        if @world.save
          invoke("Create UOD: " + @world1[:title], "adminEmail", "admin", 1)
          format.html { redirect_to :root, notice: 'World was successfully created.' }
          format.json { render :show, status: :created, location: @world }
        else
          format.html { render :new }
          format.json { render json: :root.errors, status: :unprocessable_entity }
        end
      end
    end
  end
 
 def invoke(action, email, role, worldID)
      uri = URI('http://139.59.89.51:443/submitLog')

          http = Net::HTTP.new(uri.host, uri.port)
          req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json', 'Authorization' => 'XXXXXXXXXXXXXXXX'})
          
          time = Time.now.inspect
          obj = {:worldID => worldID, :email => email, :role => "admin", :action => action, :timestamp => time}      
          req.body = JSON.generate(obj)
          res = http.request(req)

          puts "post response --------- #{res.body}"

        rescue => e
          puts "failed #{e}"
    end


  def logs
    queryUser = params[:queryUser]
    if(queryUser != nil)
      puts "queryUser name --------- "+queryUser 
      query(queryUser)
    end
  end


  def query(queryUser)
      domain_uri = 'http://139.59.89.51:443/submitUsername/'+queryUser
        
          uri = URI(domain_uri)
          req = Net::HTTP::Get.new(uri)

          res = Net::HTTP.start(uri.host, uri.port) {|http|
          http.request(req)}

          $dataList = JSON.parse(res.body)["result"]["data"]
          puts "get response --------- #{res.body}"

        rescue => e
          puts "failed #{e}"
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
