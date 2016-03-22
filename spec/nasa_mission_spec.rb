require 'nasa_mission'

describe 'nasa mission' do
  let(:nasa) { NasaMission.new }

  context 'when initialized' do
    it 'has an empty grid size' do
      expect(nasa.grid_size).to eq []
    end
    
    it 'has an empty list of rover deployed positions' do
      expect(nasa.rover_deployed_positions).to eq []
    end

    it 'has an empty list of rover move instructions' do
      expect(nasa.rover_move_instructions).to eq []
    end

    it 'has an empty list of rovers' do
      expect(nasa.rovers).to eq []
    end
  end

  context 'when launching nasa mission' do
    it 'can complete the mission' do
      nasa.action_mission_objective_file('mission_objective')
      expect(nasa.rovers[0].position).to eq ({ x: 1, y: 3, facing: :N})
      expect(nasa.rovers[1].position).to eq ({ x: 5, y: 1, facing: :E})
      expect(nasa.rovers[2].position).to eq ({ x: -1, y: 0, facing: :W})
      expect(nasa.rovers[3].position).to eq ({ x: 6, y: 5, facing: :E})
    end

    it 'can report the rover finishing positions' do
      expect(nasa).to receive(:puts).with "1 3 N"
      expect(nasa).to receive(:puts).with "5 1 E"
      expect(nasa).to receive(:puts).with "-1 0 W - POOP! A rover has fallen off the plateau. Mission failed."
      expect(nasa).to receive(:puts).with "6 5 E - POOP! A rover has fallen off the plateau. Mission failed."
      expect(nasa).to receive(:puts).with "Returning back to base."
      nasa.action_mission_objective_file('mission_objective')
    end
  end

  context 'when loading non existing file' do
    it 'prints a warning' do
      expect(nasa).to receive(:puts).with('WARNING! Mission objective file does not exist. Mission aborted.')
      nasa.load_mission_objective_file 'dummy_mission_objective'
    end
  end

  context 'when loading the mission objective file' do
    before(:each) { nasa.load_mission_objective_file 'mission_objective' }

    it 'can define the grid size' do
      expect(nasa.grid_size).to eq [5,5]
    end

    it 'can define the rover deployed positions and directions' do
      expect(nasa.rover_deployed_positions[0]).to eq [1,2,:N]
      expect(nasa.rover_deployed_positions[1]).to eq [3,3,:E]
      expect(nasa.rover_deployed_positions[2]).to eq [0,0,:N]
      expect(nasa.rover_deployed_positions[3]).to eq [5,5,:S]
    end

    it 'can define the rover move instructions' do
      expect(nasa.rover_move_instructions[0]).to eq [:L,:M,:L,:M,:L,:M,:L,:M,:M]
      expect(nasa.rover_move_instructions[1]).to eq [:M,:M,:R,:M,:M,:R,:M,:R,:R,:M]
      expect(nasa.rover_move_instructions[2]).to eq [:L,:M]
      expect(nasa.rover_move_instructions[3]).to eq [:L,:M]
    end
  end

  context 'when processing rover positions' do
    before(:each) do
      nasa.load_mission_objective_file 'mission_objective'
      nasa.define_rover_positions
    end

    it 'can process positions and directions for all rovers' do
      expect(nasa.rovers[0].position).to eq ({ x: 1, y: 2, facing: :N })
      expect(nasa.rovers[1].position).to eq ({ x: 3, y: 3, facing: :E })
      expect(nasa.rovers[2].position).to eq ({ x: 0, y: 0, facing: :N })
      expect(nasa.rovers[3].position).to eq ({ x: 5, y: 5, facing: :S })
    end
  end

  context 'when processing rover moves' do
    before(:each) do
      nasa.load_mission_objective_file 'mission_objective'
      nasa.define_rover_positions
      nasa.define_rover_moves
    end

    it 'can process moves for all rovers' do
      expect(nasa.rovers[0].position).to eq ({ x: 1, y: 3, facing: :N})
      expect(nasa.rovers[1].position).to eq ({ x: 5, y: 1, facing: :E})
      expect(nasa.rovers[2].position).to eq ({ x: -1, y: 0, facing: :W})
      expect(nasa.rovers[3].position).to eq ({ x: 6, y: 5, facing: :E})
    end
  end
end