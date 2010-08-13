desc "Fetch external trips"
task :fetch_trips, [:url] => :environment do |t, args|
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'


  unless args.url
    puts "--------- FAILED --------"
    puts "You must give a url when using this task"
    puts "try something like this"
    puts "   rake fetch_trips[\"http://www.somewhere.org/travel/cal.php\"]"
    exit
  end

  first_row = true
  keys = %w(date time destination contact travelers preferred_vehicle community notes )
  Trip.delete_all
  
  puts "Using: #{args.url}"
  count = 0
  doc = Nokogiri::HTML(open(args.url))
  doc.css('table')[6].css("tr").each do |tr|
    unless first_row
      trip = Trip.new
      tr.css("td").each_with_index do |td, i|
        break if i == 8
        if i == 0
          trip.date = Date.strptime(td.text[4,10], "%m/%d/%y")
        elsif i == 1
          trip.depart, trip.return = td.text.split(" to ")
        else
          ##puts "#{keys[i]} = #{td.text}"
          trip.update_attribute(keys[i].to_sym, td.text)
        end
      end

      #noxious hack, scrapped site lacks data integrity
      if !trip.valid?
        trip.community = 'not given'
      end

      trip.save!
    end
    first_row = false
    count += 1
  end
  puts "Loaded #{count} trips"
end
