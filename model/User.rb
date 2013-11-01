class User
	include DataMapper::Resource

	property :id,		Serial		# 
	property :login,	String		# login of user
	property :password,	String

	def verifyPassword(pass)
		password == Digest::MD5.hexdigest(pass)
	end
end