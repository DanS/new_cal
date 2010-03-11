class Destination < ActiveRecord::Base
  validates_presence_of :place, :letter
  validates_uniqueness_of :place

  def self.class_letter_for(dest)
    @dest_lookup = Hash[*[all.collect {|d| [d.place, d.letter]}].flatten]
    @dest_lookup.default = @dest_lookup['Other']
    @dest_lookup[dest]
  end
end
