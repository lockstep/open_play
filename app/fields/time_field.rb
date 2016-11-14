require "administrate/field/base"

class TimeField < Administrate::Field::Base
  include DateTimeUtilities

  def to_s
    display_time(data)
  end
end
