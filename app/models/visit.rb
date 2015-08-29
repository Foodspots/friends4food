# Represents a User visiting a Pin at a certain time
class Visit < ActiveRecord::Base
	belongs_to :user
	belongs_to :pin
end
