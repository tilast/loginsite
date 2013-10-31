class User
	include DataMapper::Resource

	property :id,		Serial		# 
	property :login,	String		# login of user
	property :password,	String

	def autorizing

	end
end