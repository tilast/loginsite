class Visits
	include DataMapper::Resource

	property :id,		Serial		# 
	property :user_id,	String		# login of user
	property :login,	String

end