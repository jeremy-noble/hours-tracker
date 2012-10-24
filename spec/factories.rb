FactoryGirl.define do

  factory :user do
    sequence(:first_name) {|i| "Jeremy#{i}"}
    sequence(:last_name) {|i| "Kay#{i}"}
    sequence(:email) {|i| "jeremy#{i}@jeremyisrad.org"}
    default_hourly_rate 150
    password "123456"
    password_confirmation { |u| u.password }

    factory :admin do
      admin true
    end
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