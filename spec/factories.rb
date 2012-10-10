FactoryGirl.define do

  factory :user do
    sequence(:name) {|i| "Jeremy Kay#{i}"}
    sequence(:email) {|i| "jeremy#{i}@jeremyisrad.org"}
    default_hourly_rate 150
    password "123456"
    password_confirmation { |u| u.password }
  end

  factory :time_sheet do
    association :user
  end

  factory :entry do
    sequence(:date) { |i| i.day.ago }
    hours 9.5
    association :time_sheet
  end

end