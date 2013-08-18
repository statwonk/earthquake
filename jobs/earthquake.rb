require 'httparty'
require 'sinatra'
require 'pry-debugger'

# This file shows the latest earthquake in the world and size.
# Parameters
#   - current_mag = the magnitude of the latest earthquake
#   - current_place = the place of the lastest earthquake
#   - current_time = time of event
points = []
(1..10).each do |i|
  points << { x: i, y: 0 }
end
last_x = points.last[:x]

SCHEDULER.every '5s' do
   data = HTTParty.get('http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson').to_hash["features"].first["properties"]

    current_mag = data["mag"]
    current_place = data["place"]
    current_time = Time.at(data["time"] / 1000)
    
    page_time = Time.now

    points.shift
    last_x += 1
    points << { x: last_x, y: current_mag }

  send_event('data_id', { page_time: page_time, magnitude: current_mag, place: current_place, time: current_time, points: points })
end
