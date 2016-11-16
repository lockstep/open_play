require "administrate/field/base"

class DateField < Administrate::Field::Base
  include DateTimeUtilities

  def to_s
    present_date_in_day_month_year_format(data)
  end
end
