class Vehicle < ActiveRecord::Base
  validates_uniqueness_of :name
  named_scope :ordered, {:order => 'not_dr_vehicle, firm_assignment , name'}
end
