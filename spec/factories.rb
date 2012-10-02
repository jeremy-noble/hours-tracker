FactoryGirl.define do

  factory :user do
    sequence(:name) {|i| "Jeremy Kay#{i}"}
    # email    "jeremy@isawesome.com"
    # password "12345"
    # password_confirmation "12345"
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