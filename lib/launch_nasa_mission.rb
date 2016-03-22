require_relative './nasa_mission'

mission_objective_file = ARGV.first || ""
new_mission            = NasaMission.new
new_mission.action_mission_objective_file(mission_objective_file)