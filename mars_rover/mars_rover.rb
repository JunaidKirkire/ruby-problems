
# puts "Please enter the co-ordinates in the format => [x co-ordinate] [y co-ordinate]"
# x, y = gets.chomp.split(" ").collect { |ele| ele.to_i }
# #puts "Current co-ordinates => #{x} #{y}"

# puts "Enter orientation (N, E, W, S)"
# orientation = gets.chomp.upcase
# #puts "Orientation => #{orientation}"

# puts "Enter directions - "
# directions = gets.chomp.upcase #"MMRMMRMRRM"

class Rover
	OrientationMatrix = 
		{'N' => ['W', 'E'], 'S' => ['E', 'W'], 'E' => ['N', 'S'], 'W' => ['S', 'N']}

	def initialize(x_coordinate, y_coordinate)
		@x_coordinate = x_coordinate
		@y_coordinate = y_coordinate
	end

	def has_fallen_off?(length, breadth)
		@x_coordinate > length || @y_coordinate > breadth
	end

	def rover_movement(orientation, directions, obj_plateau)
		directions.split("").each do |direction|
			orientation_index = -1
			if direction == 'L'
				orientation_index = 0		
			elsif direction == 'R'
				orientation_index = 1
			else
				#M => Move by 1
				case orientation
					when "N" 
						@y_coordinate += 1
					when "S" 
						@y_coordinate -= 1
					when "E" 
						@x_coordinate += 1
					when "W" 
						@x_coordinate -= 1
				end

				if has_fallen_off?(obj_plateau.length, obj_plateau.breadth)
					puts "Has fallen off!"
					return "Has fallen off the plateau!"
				end

				next
			end
			orientation = OrientationMatrix[orientation][orientation_index]
		end
		"#{@x_coordinate} #{@y_coordinate} #{orientation}"
	end
end

class Plateau
	def initialize(length, breadth)
		@length = length
		@breadth = breadth
	end

	attr_accessor :length, :breadth
end

puts "Enter plateau co-ordinates"
plateau_x_coord, plateau_y_coord = gets.chomp.split(" ").collect { |e| e.to_i  }
p = Plateau.new plateau_x_coord, plateau_y_coord

puts "Enter rover co-ordinates, orientation and directions"
rover_x_coord, rover_y_coord, orientn = gets.chomp.split(" ")
rover = Rover.new rover_x_coord.to_i, rover_y_coord.to_i

directns = gets.chomp
puts rover.rover_movement(orientn, directns, p)

#puts rover_movement(3, 3, 'E', 'MMRMMRMRRM')

require 'test/unit'

class RoverUnitTest < Test::Unit::TestCase

	def test_orientation
		p = Plateau.new 5, 5
		assert_equal("1 3 N", Rover.new(1, 2).rover_movement('N', 'LMLMLMLMM', p), "Failed!")

		assert_equal("5 1 E", Rover.new(3, 3).rover_movement('E', 'MMRMMRMRRM', p), "Failed!")
	end

end

#TestRunner.run(RoverUnitTest)