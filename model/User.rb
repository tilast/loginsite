class User
	include DataMapper::Resource

	property :id,		Serial		# 
	property :login,	String		# login of user
	property :password,	String

	has n, :visits

	def verifyPassword(pass)
		password == Digest::MD5.hexdigest(pass)
	end

	def createVisit
		visits.create
	end

	def getVisits
		Visit.all(:user_id => id)
	end
end