FactoryGirl.define do

  factory :user do
    name     "Jeremy Kay"
    # email    "jeremy@isawesome.com"
    # password "12345"
    # password_confirmation "12345"
  end

  factory :time_sheet do
    association :user
  end

  factory :entry do
    sequence(:date) { |i| i.day.ago }
    sequence(:hours) { |i| i }
    association :time_sheet
  end

end