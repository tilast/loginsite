class Visit
	include DataMapper::Resource

	property :id,		Serial		# 
	property :user_id,	String		# login of user
	property :date,		DateTime,	default: DateTime.now

	belongs_to :user
end