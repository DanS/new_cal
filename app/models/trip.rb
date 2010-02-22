class Trip < ActiveRecord::Base
  named_scope :upcoming, {:conditions => ["date >= ?", Date.today], :order => 'date, depart'}
  named_scope :next_3_months, {:conditions =>
    ["date >= ? AND date <= ?", Date.today, Date.today + 3.months]}
  named_scope :for_week_year, lambda {|wk, yr| {:conditions =>
    ["strftime('%W', date) = ? AND strftime('%Y', date) = ?", sprintf("%02d", wk), "#{yr}"]}}

  def self.list_destinations
    dests = Hash.new {|hash, key| hash[key] = 0}
    upcoming.each {|t| dests[t.destination] = dests[t.destination] += 1}
    dests.collect {|k,v| k + "(#{v})"}.sort
  end

  def self.by_date_string
    out = Hash.new {|hash, key| hash[key] = []}
    upcoming.each do |t| 
      date_str = t.date.strftime("%Y%m%d")
      out[date_str] = out[date_str] << t 
    end
    out
  end
  
  
end
