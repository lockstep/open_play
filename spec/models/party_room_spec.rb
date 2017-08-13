describe PartyRoom do
  before { @party_room = create(:party_room) }

  describe '#allocate_reservables' do
    context 'number_of_players is more than maximum_players_per_sub_reservable' do
      it 'allocates sub_reservables' do
        @party_room.update(maximum_players: 40)
        reservable3 = create(:lane, name: 'lane 3', activity: @party_room.activity)
        @party_room.children.create(
          parent_reservable_id: @party_room.id,
          sub_reservable_id: reservable3.id,
          priority_number: 3
        )
        allocated_reservables = @party_room.allocate_reservables(35)

        expect(allocated_reservables.length).to eq 2
        expect(allocated_reservables[@party_room.sub_reservables.first.id.to_s]).to eq 20
        expect(allocated_reservables[@party_room.sub_reservables.second.id.to_s]).to eq 15
      end
    end

    context 'number_of_players is less than maximum_players_per_sub_reservable' do
      it 'allocates sub_reservables' do
        allocated_reservables = @party_room.allocate_reservables(10)

        expect(allocated_reservables.length).to eq 1
        expect(allocated_reservables[@party_room.sub_reservables.first.id.to_s]).to eq 10
      end
    end
  end
end
