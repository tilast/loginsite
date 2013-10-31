require 'data_mapper'
require 'dm-sqlite-adapter'
require 'sinatra'

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/model/login.db")
require_relative "model/User.rb"

DataMapper.finalize
DataMapper.auto_migrate!

enable :sessions

get "/login" do
	erb :form
end

post "/login" do

	if params[:action] == "login"
		user = User.get(:login => params[:login])

		if user != nil && user.password == Digest::MD5.hexdigest(params[:password])
			redirect "/"
		else
			redirect "/login"
		end
			
	elsif params[:action] == "signup"
		user = User.create(
			:login 		=>	params[:login],
			:password 	=>	Digest::MD5.hexdigest(params[:password]),
		)
		user.save

		redirect "/"
	end

end

get "/" do
"here will be an records"
end