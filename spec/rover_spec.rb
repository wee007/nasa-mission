require 'rover'

describe 'rover' do
  let(:grid_size) { [5,5] }

  describe 'rover_one' do
    let(:rover_one) { Rover.new(1,2,:N) }

    context 'when initialized' do
      it 'has a position and a direction' do
        expect(rover_one.position).to eq ({ x: 1, y: 2, facing: :N })
      end
    end

    context 'when rotating' do
      it 'can rotate 90 degrees right' do
        rover_one.rotate(:R)
        expect(rover_one.position[:facing]).to eq :E
      end
      it 'can rotate 90 degrees left' do
        rover_one.rotate(:L)
        expect(rover_one.position[:facing]).to eq :W
      end
    end

    context 'when moving within the plateau' do
      it 'can move in the direction it is facing' do
        rover_one.rotate(:L)
        rover_one.move
        expect(rover_one.position).to eq ({ x: 0, y: 2, facing: :W })
        expect(rover_one.finished_position(grid_size)).to eq ("0 2 W")
      end
    end
  end

  describe 'rover_two' do
    let(:rover_two) { Rover.new(5,5,:S) }

    context 'when moving outside the plateau' do
      it 'can move in the direction it is facing' do
        rover_two.rotate(:L)
        rover_two.move
        expect(rover_two.position).to eq ({ x: 6, y: 5, facing: :E })
        expect(rover_two.finished_position(grid_size)).to eq ("6 5 E - POOP! A rover has fallen off the plateau. Mission failed.")
      end
    end
  end
end