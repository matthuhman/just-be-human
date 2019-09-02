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




User.destroy_all


if Rails.env == "development"
  User.create({
    username: "test1",
    email: "test1@test.com",
    first_name: "Test1",
    last_name: "Huhman",
    postal_code: "80205",
    password: "password",
    password_confirmation: "password",
    region: "CO",
    city: "Denver",
    confirmed_at: Time.now,
    birth_date: Date.strptime("30/11/1991", "%d/%m/%Y")
  })
  User.create({
    username: "arren",
    email: "arren@test.com",
    first_name: "Arren",
    last_name: "Alexander",
    postal_code: "80211",
    password: "password",
    password_confirmation: "password",
    region: "CO",
    city: "Denver",
    confirmed_at: Time.now,
    birth_date: Date.strptime("25/10/1992", "%d/%m/%Y")
  })
  User.create({
    username: "test2",
    email: "test2@test.com",
    first_name: "Test2",
    last_name: "Huhman",
    postal_code: "80205",
    password: "password",
    password_confirmation: "password",
    region: "CO",
    city: "Denver",
    confirmed_at: Time.now,
    birth_date: Date.strptime("30/11/1991", "%d/%m/%Y")
  })
  User.create({
    username: "test-under16",
    email: "test-under16@test.com",
    first_name: "Test2",
    last_name: "Huhman",
    postal_code: "80205",
    password: "password",
    password_confirmation: "password",
    region: "CO",
    city: "Denver",
    confirmed_at: Time.now,
    birth_date: Date.strptime("30/11/2011", "%d/%m/%Y")
  })
end
