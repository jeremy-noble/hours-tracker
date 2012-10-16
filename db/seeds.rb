# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# add admin user

user = User.create(name: 'Jeremy Kay', email: 'jeremy@nobledesktop.com', 
    default_hourly_rate: 125, password: 'noble', password_confirmation: 'noble')
user.toggle!(:admin)

user_names = ['George', 'Jerry', 'Elaine', 'Kramer', 'Newman']

user_names.each do |name|

  user = User.create(name: name, email: "#{name}@nobledesktop.com", 
    default_hourly_rate: 75, password: 'foobar', password_confirmation: 'foobar')

  7.times do |i| 

    time_sheet = TimeSheet.new
    time_sheet.user_id = user.id

    # mark some of them "paid"
    if i < 4
      time_sheet.paid = true
    end

    time_sheet.save
    
    5.times do |i|
      time_sheet.entries.create(date: i.days.ago, hours: rand(1..10))
    end 

  end

end