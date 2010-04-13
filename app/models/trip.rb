class Trip < ActiveRecord::Base
  validates_presence_of :date, :contact, :destination, :community
  named_scope :upcoming, {:conditions => ["date >= ?", Date.today], :order => 'date, depart'}
  named_scope :next_3_months, {:conditions =>
      ["date >= ? AND date <= ?", Date.today, Date.today + 3.months]}
  named_scope :for_week_year, lambda {|wk, yr| {:conditions =>
        ["strftime('%W', date) = ? AND strftime('%Y', date) = ?", sprintf("%02d", wk), "#{yr}"]}}
  #default dates
  first = Date.parse("2000-01-01")
  last = Date.parse("2100-01-01")
  named_scope :to_destination, lambda {|*dest| {:conditions => ["destination like ?", dest[0] || "%"]}}
  named_scope :between_dates, lambda {|*d| 
    {:conditions => ["julianday(?) - 0.5 <= julianday(date) AND
         julianday(date) <= julianday(?) + 0.5", d[0] || first, d[1] || last]}}

  def destination_id
    begin
      Destination.find_by_place(destination).id
    rescue
      other_val = Destination.find_by_place('Other').id
      if other_val
        return other_val
      else
        raise "Destination table has no record where place == 'Other' "
      end
    end
  end


  def letter
    Destination.find(destination_id).letter
  end

  def self.list_destinations
    #produces a hash, keys are upcoming destinations, values are an array of count of trips
    #to that destination, and css style letter for right color. like  "Rutledge => [3, 'R']
    dests = Hash.new {|hash, key| hash[key] = 0}
    output = {}
    upcoming.each {|t| dests[t.destination] = dests[t.destination] += 1}
    dests.each_pair {|k, v| output[k] = [v, Destination.class_letter_for(k)]}
    return output
  end

  def self.by_date_string(params)
    trips_by_date = Hash.new {|hash, key| hash[key] = []}
    filtered(params).each do |t|
      date_str = t.date.strftime("%Y%m%d")
      trips_by_date[date_str] = trips_by_date[date_str] << t
    end
    trips_by_date.default = []
    trips_by_date
  end
  
  def self.on_date(date)
    self.all.select {|t| t.date.strftime("%Y-%m-%d") == date.to_s}
  end
  
  def self.destinations_for_date(date)
    self.all.select {|t| t.date.strftime("%Y-%m-%d") == date.to_s}.collect {|t| t.destination}.uniq
  end

  def self.filtered(filters)
    Trip.to_destination(filters[:destination]).between_dates(filters[:start_date], filters[:end_date])
  end
end
