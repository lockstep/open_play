module ConfirmationOrderConcerns
  extend ActiveSupport::Concern

  def sms_message
    <<-HEREDOC
      Thank you for booking with OpenPlay!
      Booking Confirmation Order ID: #{id}
      Date: #{booking_date.strftime('%A, %B %-d')}
      Place: #{booking_place}
      Price: $#{total_price}
    HEREDOC
  end

  def client_phone_number
    user.present? ? user.phone_number : guest.phone_number
  end
end
