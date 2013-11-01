require 'data_mapper'
require 'dm-sqlite-adapter'
require 'sinatra'
require 'sinatra/base'

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/model/login.db")
load "./model/User.rb"
load "./model/Visits.rb"

DataMapper.finalize
DataMapper.auto_upgrade!	

enable :sessions

get "/login" do
	session.delete(:login)
	erb :form, :locals => {:wrong_password => params["wrong_password"]}
end

post "/login" do

	if params[:action] == "login"
		user = User.first(:login => params[:name])

		if user != nil && user.verifyPassword(params[:password])
			session["login"] = params[:name]
			Visits.create(
				:user_id => user.id
			)
			redirect "/"
		else
			redirect "/login?wrong_password=true"
		end
			
	elsif params[:action] == "signup"

		user = User.create(
					:login 		=>	params[:name],
					:password 	=>	Digest::MD5.hexdigest(params[:password]),
				)

		session["login"] = params[:name]
		Visits.create(
				:user_id => user.id
		)

		redirect "/" 
	end

end

get "/" do
	if session["login"]
		Visits.all.inspect
	else
		redirect "/login"
	end
end