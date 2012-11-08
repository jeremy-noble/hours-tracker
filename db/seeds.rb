# add admin user
user = User.create(first_name: 'admin', last_name: 'admin', email: 'admin@example.com', 
    default_hourly_rate: 250, password: 'admin', password_confirmation: 'admin')
user.toggle!(:admin)

# add normal users
users = Array.new

users << {first_name: 'George', last_name: 'Constanza'}
users << {first_name: 'Jerry', last_name: 'Seinfeld'}
users << {first_name: 'Elaine', last_name: 'Benes'}
users << {first_name: 'Cosmo', last_name: 'Kramer'}

users.each do |user|

  user = User.create(first_name: user[:first_name], last_name: user[:last_name], email: "#{user[:first_name]}@example.com", 
    default_hourly_rate: 150, password: 'foobar', password_confirmation: 'foobar')

  7.times do |i| 

    time_sheet = TimeSheet.new
    time_sheet.user_id = user.id

    # mark all but last "paid"
    if i < 6
      time_sheet.paid = true
    end

    time_sheet.save
    
    5.times do |i|
      time_sheet.entries.create(date: i.days.ago, hours: rand(1..10))
    end 

  end

end