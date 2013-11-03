require 'data_mapper'
require 'dm-sqlite-adapter'
require 'dm-migrations'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'

if(!File.exists?("#{Dir.pwd}/model/login.db"))
	File.new("#{Dir.pwd}/model/login.db", "w")
end

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/model/login.db")


load "./model/User.rb"
load "./model/Visits.rb"

DataMapper.finalize
DataMapper.auto_upgrade!	

class MyApp < Sinatra::Base
	enable :sessions
	register Sinatra::Flash

	get "/login" do
		session.delete(:login)
		erb :form, :locals => {:wrong => flash[:error]}
	end

	post "/login" do

		if params[:action] == "login"
			user = User.first(:login => params[:name])

			if user != nil && user.verifyPassword(params[:password])
				session["login"] = params[:name]
				user.createVisit
				redirect "/"
			else
				flash[:error] = "Wrong login or password, plz, try again"
				redirect "/login"
			end
		
		elsif params[:action] == "signup"

			if User.get(:login => params[:name]) 
				flash[:error] = "Such user already exists"
				redirect "/login"
			else
				user = User.create(
						:login 		=>	params[:name],
						:password 	=>	Digest::MD5.hexdigest(params[:password]),
					)

				user.createVisit

				session["login"] = params[:name]

				redirect "/"
			end
		end

	end

	get "/" do
		if session["login"]
			erb :visits, :locals => {:userVisits => User.first(:login => session["login"]).getVisits}
		else
			redirect "/login"
		end
	end
end