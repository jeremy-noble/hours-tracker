# add admin user
user = User.create(name: 'admin', email: 'admin@example.com', 
    default_hourly_rate: 125, password: 'admin', password_confirmation: 'admin')
user.toggle!(:admin)

# add normal users
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