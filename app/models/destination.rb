class Destination < ActiveRecord::Base
  validates_presence_of :place, :letter
  validates_uniqueness_of :place
end
