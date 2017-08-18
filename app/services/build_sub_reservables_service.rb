class BuildSubReservablesService
  def initialize(reservable, reservable_params, action_name)
    @reservable = reservable
    @reservable_params = reservable_params
    @action_name = action_name
  end

  def call
    return unless reservable.party_room?
    sub_reservables = {}
    reservable.sub_reservables_candidate.each do |reservable|
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

  attr_reader :reservable, :reservable_params, :action_name
  attr_accessor :sub_reservables_hash

  def sub_reservables_params
    return {} if @reservable_params[:sub_reservables].blank?
    return @sub_reservables_hash if @sub_reservables_hash
    sub_reservables_hash = {}
    @reservable_params[:sub_reservables].values.each do |sub_reservable|
      sub_reservables_hash[sub_reservable['id']] = {
        priority_number: sub_reservable['priority_number']
      }
    end
    @sub_reservables_hash = sub_reservables_hash
  end

  def should_mark_reservable_as_checked(reservable)
    return false if action_name == 'new'
    sub_reservables_params[reservable.id.to_s].present?
  end

  def assign_priority_number(reservable)
    return nil if action_name == 'new'
    return nil if sub_reservables_params[reservable.id.to_s].blank?
    sub_reservables_params[reservable.id.to_s][:priority_number]
  end
end
