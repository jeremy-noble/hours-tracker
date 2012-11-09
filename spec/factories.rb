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

    factory :paid_time_sheet do
      after(:create) do |paid_time_sheet|
        paid_time_sheet.mark_paid
      end
    end

    factory :time_sheet_hourly do
      after(:create) do |time_sheet_hourly|
        FactoryGirl.create(:entry, time_sheet: time_sheet_hourly, hours: 10)
        FactoryGirl.create(:entry, time_sheet: time_sheet_hourly, hours: 11)
        FactoryGirl.create(:entry, time_sheet: time_sheet_hourly, hours: 3.5)
      end
    end

    factory :time_sheet_salary do
      after(:create) do |time_sheet_salary|
        FactoryGirl.create(:entry, time_sheet: time_sheet_salary, hours: 3, hourly_rate: 75)
        FactoryGirl.create(:entry, time_sheet: time_sheet_salary, hours: 11) #should get default hourly_rate from user "150"
        FactoryGirl.create(:entry, time_sheet: time_sheet_salary, hours: 3.5, hourly_rate: 60)
      end
    end
  end

  factory :entry do
    sequence(:date) { |i| i.day.ago }
    hours 9.5
    association :time_sheet
  end

end