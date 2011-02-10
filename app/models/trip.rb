class Trip < ActiveRecord::Base
  before_validation {|t| if t.return.nil?; t.return = t.depart + 2.hours; end }
  validates_presence_of :date, :contact, :destination, :community, :depart, :return
  validates_each :return do |record, attr, value|
    if record.depart.nil?
      record.errors.add attr, "Depature time can't be blank"
    else
      record.errors.add attr, "Return time can't be earlier than departure time" if value <= record.depart
    end
  end
  named_scope :upcoming, {:conditions => ["date >= ?", Date.today], :order => 'date, depart'}
  named_scope :next_3_months, {:conditions =>
      ["date >= ? AND date <= ?", Date.today, Date.today + 3.months]}
  
  named_scope :to_destination, lambda {|*dest| {:conditions => ["destination like ?", dest[0] || "%"]}}

  #default dates
  earliest_date = Date.parse("2000-01-01")
  oldest_date = Date.parse("2100-01-01")
  named_scope :between_dates, lambda {|*d|
    {:conditions => ["date_trunc('day', date) BETWEEN ? AND ?", d[0] || earliest_date, d[1] || oldest_date]}}

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

  def duration
    #return an array of numbers representing hours and half hours of trip duration
    #ranges can't deal with floats so numbers are doubled and odd numbers considered half hours
    depart_time = self.depart.min == 0 ? self.depart.hour * 2: ((self.depart.hour + 0.5) * 2).to_i
    return_time = self.return.min == 0 ? self.return.hour * 2: ((self.return.hour + 0.5) * 2).to_i
    (depart_time...return_time).collect {|x|x % 2 == 0 ? x/2 : (x/2) + 0.5 }
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
    today = Date.today
    trips_by_date = Hash.new {|hash, key| hash[key] = []}
    filtered(params).each do |t|
      date_str = t.date.strftime("%Y%m%d")
      trips_by_date[date_str] = trips_by_date[date_str] << t if t.date >= today 
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

  def self.to_dashed_date_string(date)
    case date
    when nil
      return nil
    when Date
      return date.strftime("%Y-%m-%d")
    when String
      return date.insert(4, '-').insert(-3,'-')
    end
  end

  def self.filtered(filters)
    start_date = to_dashed_date_string(filters[:start_date])
    end_date = to_dashed_date_string(filters[:end_date])
    Trip.to_destination(filters[:destination]).between_dates(start_date, end_date)
  end

  class ByHour
    #TODO refactor this for better separation of concerns
    #wrap a hash so it returns week_col_class if key not present
    attr_reader :hours
    def initialize(hours)
      @hours = hours
    end
    def has_hour?(date, vehicle, hour)
      week_col_class = Date.parse(date).strftime("%a")
      if @hours.has_key?(date) && @hours[date].has_key?(vehicle) && @hours[date][vehicle].has_key?(hour)
        trip_data = @hours[date][vehicle][hour]
        return ["class=\"#{vehicle.gsub(' ', '-') + '-trip'} #{week_col_class}\""] + trip_data
      else
        return ["class=\"#{week_col_class}\""]
      end
    end
  end

  def self.by_hour(start_date, end_date)
    #TODO refactor this for better separation of concerns    
    trips_by_hour = {} #Hash.new{|h,k| h[k]=Hash.new(&h.default_proc) }
    filtered(:start_date=>start_date, :end_date=>end_date).map do |t|
      date = t.date.strftime("%Y%m%d")
      data = [t.id, t.contact, t.destination]
      t.duration.each do |hour|
        unless trips_by_hour.has_key?(date); trips_by_hour[date] = {}; end
        unless trips_by_hour[date].has_key?(t.preferred_vehicle)
          trips_by_hour[date][t.preferred_vehicle] = {}
        end
        trips_by_hour[date][t.preferred_vehicle][hour] = data
      end
    end
    return ByHour.new(trips_by_hour)
  end

end
