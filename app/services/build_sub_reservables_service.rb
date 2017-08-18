class BuildSubReservablesService
  def initialize(reservable:, new_record:, reservable_params: nil)
    @reservable = reservable
    @reservable_params = reservable_params
    @new_record = new_record
  end

  def call
    return unless reservable.party_room?
    sub_reservables = {}
    Reservable.sub_reservables_candidate(reservable.activity_id).each do |reservable|
      sub_reservables[reservable.id.to_s] = {
        name: reservable.name,
        type: reservable.type,
        priority_number: assign_priority_number(reservable),
        checked: should_mark_reservable_as_checked(reservable),
        disabled: !should_mark_reservable_as_checked(reservable)
      }
    end
    sub_reservables
  end

  private

  attr_reader :reservable, :reservable_params, :new_record
  attr_accessor :sub_reservables_hash

  def sub_reservables_params
    return {} if reservable_params[:sub_reservables].blank?
    return @sub_reservables_hash if @sub_reservables_hash
    @sub_reservables_hash = {}
    reservable_params[:sub_reservables].values.each do |sub_reservable|
      sub_reservables_hash[sub_reservable['id']] = {
        priority_number: sub_reservable['priority_number']
      }
    end
    @sub_reservables_hash = sub_reservables_hash
  end

  def should_mark_reservable_as_checked(reservable)
    return false if new_record
    sub_reservables_params[reservable.id.to_s].present?
  end

  def assign_priority_number(reservable)
    return nil if new_record
    return nil if sub_reservables_params[reservable.id.to_s].blank?
    sub_reservables_params[reservable.id.to_s][:priority_number]
  end
end
