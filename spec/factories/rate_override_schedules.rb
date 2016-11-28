FactoryGirl.define do
  factory :rate_override_schedule do
    label 'black friday'
    overridden_on '7 Nov 2016'
    overridden_days ''
    overridden_all_day true
    overridden_specific_day true
    overriding_begins_at ''
    overriding_ends_at ''
    overridden_all_reservables true
    price '10.0'
    per_person_price '15.0'
    activity { create(:bowling) }
  end
end
