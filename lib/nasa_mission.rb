require_relative './rover.rb'

class NasaMission
  attr_reader \
    :grid_size,
    :rover_deployed_positions,
    :rover_move_instructions,
    :rovers

  def initialize
    @grid_size                = []
    @rover_deployed_positions = []
    @rover_move_instructions  = []
    @rovers                   = []
  end

  def action_mission_objective_file(mission_objective_file)
    load_mission_objective_file(mission_objective_file)
    define_rover_positions
    define_rover_moves
    display_rover_finished_positions
  end

  def load_mission_objective_file(mission_objective_file)
    File.exist?(mission_objective_file) \
      ? _read_mission_objective_file(mission_objective_file)
      : (puts "WARNING! Mission objective file does not exist. Mission aborted.")
  end

  def define_rover_positions
    rover_deployed_positions.each do |position|
      x_coordinate, y_coordinate, facing = position[0], position[1], position[2]
      rovers << Rover.new(x_coordinate, y_coordinate, facing)
    end
  end

  def define_rover_moves
    rovers_count = rovers.count
    rovers_count.times do |rover|
      rover_move_instructions[rover].each do |instruction|
        instruction == :M ? rovers[rover].move : rovers[rover].rotate(instruction)
      end
    end
  end

  def display_rover_finished_positions
    rovers.each { |rover| puts rover.finished_position(@grid_size) }
    puts "Returning back to base."
  end

  private

  def _read_mission_objective_file(mission_objective_file)
    mission_objective = File.open(mission_objective_file) { |file| file.readlines }
    _define_grid_size(mission_objective.shift)
    _process_mission_objective(mission_objective)
  end

  def _process_mission_objective(mission_objective)
    mission_objective.each_with_index do |info, index|
      index.even? \
        ? _rover_deployed_positions(info)
        : _rover_move_instructions(info)
    end
  end

  def _define_grid_size(mission_objective)
    @grid_size = mission_objective.chomp.split(" ").map(&:to_i)
  end

  def _rover_deployed_positions(info)
    info = info.chomp.split(' ')
    x_coordinate, y_coordinate, facing = info[0].to_i, info[1].to_i, info[2].upcase.to_sym
    rover_deployed_positions << [x_coordinate, y_coordinate, facing]
  end

  def _rover_move_instructions(info)
    info = info.chomp.chars.map(&:to_sym)
    rover_move_instructions << info
  end
end