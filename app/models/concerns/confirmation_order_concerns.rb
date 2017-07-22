module ConfirmationOrderConcerns
  extend ActiveSupport::Concern

  def sms_message
    price = (total_price % 1).zero? ? total_price.to_i : '%.2f' % total_price
    <<-HEREDOC
      Thank you for booking with OpenPlay!
      Booking Confirmation Order ID: #{id}
      Date: #{booking_date.strftime('%A, %B %-d')}
      Place: #{booking_place}
      Price: $#{price}
    HEREDOC
  end

  def client_phone_number
    user.present? ? user.phone_number : guest.phone_number
  end
end
