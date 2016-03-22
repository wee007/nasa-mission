class Rover
  LOWER_AXIS_COORDINATE = 0

  DIRECTION = {
    :R => [:N, :E, :S, :W, :N],
    :L => [:N, :W, :S, :E, :N]
  }

  MOVEMENT = {
    :N => [:y, 1],
    :E => [:x, 1],
    :S => [:y, -1],
    :W => [:x, -1]
  }

  attr_reader :position

  def initialize(x_coordinate, y_coordinate, facing)
    @position = {
      x:      x_coordinate,
      y:      y_coordinate,
      facing: facing
    }
  end

  def move
    axis, step = MOVEMENT[position[:facing]]
    position[axis] += step
  end

  def rotate(direction)
    DIRECTION[direction].each_cons(2) do |facing, next_facing|
      position[:facing] = next_facing and break if facing == position[:facing]
    end
  end

  def finished_position(grid_size)
    mission_result = "#{position[:x]} #{position[:y]} #{position[:facing]}"
    mission_result += " - POOP! A rover has fallen off the plateau. Mission failed." if _outside_grid?(grid_size, position[:x], position[:y])
    mission_result
  end

  private

  def _outside_grid?(grid_size, x_coordinate, y_coordinate)
    upper_x_coordinate = grid_size[0]
    upper_y_coordinate = grid_size[1]
    x_coordinate < LOWER_AXIS_COORDINATE or x_coordinate > upper_x_coordinate or \
    y_coordinate < LOWER_AXIS_COORDINATE or y_coordinate > upper_y_coordinate
  end
end