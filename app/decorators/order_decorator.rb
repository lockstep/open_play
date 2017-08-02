class OrderDecorator < Draper::Decorator
  delegate_all

  def social_media_title
    "I just booked a #{activity_unit} of "\
    "#{readable_activity_type} on OpenPlay at #{object.activity_name}"
  end

  private

  def readable_activity_type
    object.activity_type.underscore.split('_').join(' ')
  end

  def activity_unit
    object.activity_type == 'Bowling' ? 'round' : 'room'
  end
end
