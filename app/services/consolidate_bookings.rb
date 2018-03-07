class ConsolidateBookings
  def initialize(time_slots, date)
    @time_slots = time_slots
    @date = date
  end

  def call(number_of_players = 1)
    consolidate_bookings(build_slots(number_of_players))
  end

  private

  attr_reader :time_slots, :date

  def build_slots(number_of_players)
    slots = {}
    @time_slots.each do |reservable_id, reservable_time_slots|
      reservable_time_slots.each do |time_slot|
        slots[reservable_id] = (slots[reservable_id] || []) << {
          start_time: extract_start_end_times(time_slot, 'start_time'),
          end_time: extract_start_end_times(time_slot, 'end_time'),
          booking_date: @date,
          number_of_players: number_of_players
        }
      end
    end
    slots
  end

  def consolidate_bookings(slots)
    bookings = []
    slots.each do |item|
      item[1].each_with_index do |slot, index|
        if index != 0 && slot[:start_time] == item[1][index-1][:end_time]
          bookings.last.end_time = convert_to_time(slot[:end_time])
        else
          bookings << build_booking(slot, item[0])
        end
      end
    end
    bookings
  end

  def build_booking(slot, reservable_id)
    Booking.new(slot.merge({reservable_id: reservable_id}))
  end

  def convert_to_time(time)
    DateTime.parse(time).to_time
  end

  def extract_start_end_times(time_slots, slot)
    start_end_times = time_slots.split(',')
    slot == "start_time" ? start_end_times[0] : start_end_times[1]
  end
end
