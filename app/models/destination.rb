class Destination < ActiveRecord::Base
  validates_presence_of :place, :letter
end
