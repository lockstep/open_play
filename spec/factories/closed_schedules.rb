FactoryGirl.define do
  factory :closed_schedule do
    label 'holiday'
    closed_on '7 Nov 2016'
    closed_days []
    closed_all_day true
    closed_specific_day true
    closing_begins_at ''
    closing_ends_at ''
    activity { create(:bowling) }
  end
end
