# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'us-zip-code-latitude-and-longitude.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1', :col_sep => ?;)
csv.each do |row|
  t = Geopoint.new
  t.city = row['city']
  t.zip = row['zip']
  t.state = row['state']
  
  t.latitude = row['latitude']
  t.longitude = row['longitude']
  t.time_zone = row['time_zone']
  t.dst_flag = row['dst_flag']
  t.coordinates = row['geopoint,']
  t.save
  puts "#{t.zip}:::: #{t.coordinates} saved"
end