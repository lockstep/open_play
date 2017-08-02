require "administrate/field/base"

class MoneyField < Administrate::Field::Base
  def self.permitted_attribute(attr)
    [:"#{attr}_cents", :"#{attr}_currency"]
  end

  def to_s
    data
  end

  def choices
    %w(USD CAD)
  end
end
