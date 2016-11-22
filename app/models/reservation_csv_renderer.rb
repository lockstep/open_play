class ReservationCsvRenderer
  include OrderHelper
  def generate_csv(reservations)
    CSV.generate(headers: true) do |csv|
      render_header(csv)
      render_reservations(csv, reservations)
    end
  end

  private

  def render_header(csv)
    csv << [
      "No.", "Customer", "Activity", "Reservable", "Time", "Date",
      "Number of people","Total Price", "Status"
    ]
  end

  def render_reservations(csv, reservations)
    reservations.each do |reservation|
      row = []
      row << reservation.order_id
      row << reservation.order_reserver_full_name
      row << reservation.reservable_activity_name
      row << reservation.reservable_name
      row << game_period(reservation.start_time, reservation.end_time)
      row << reservation_date(reservation.booking_date)
      row << reservation.number_of_players
      row << "$ #{reservation.booking_price}"
      row << status(reservation)
      csv << row
    end
  end

  def game_period(start_time, end_time)
    "#{start_time.strftime("%I:%M %p")} - #{end_time.strftime("%I:%M %p")}"
  end

  def reservation_date(date)
    date.strftime("%A, %B %e")
  end
end
