def count_ones(count)
	no_of_threes, no_of_ones = count.divmod 3
	#puts "#{count} #{no_of_threes}, #{no_of_ones}"
	no_of_threes * 1000 + no_of_ones * 100
end

def count_fives(count)
    no_of_threes, no_of_ones = count.divmod 3
    #puts "#{count} #{no_of_threes}, #{no_of_ones}"
    no_of_threes * 500 + no_of_ones * 50
end

def score2(dice)
  # puts "in score"
	digit_count = Hash.new(0)
	score = 0
	temp = 0

	dice.each { |num| digit_count[num] += 1 }
	#puts digit_count
	
	digit_count.each do |num, count|
		temp = case num
			when 1
				count_ones(count)
			when 5
				count_fives(count)
			else
				no_of_others, = count.divmod 3
				#puts "#{num}, #{no_of_others}"
				num * 100 * no_of_others
		end

		dice.delete(num) if temp > 0
		# puts "dice - #{dice}"
		# puts "score - #{score}"
		# puts "temp - #{temp}"
		score += temp
	end
	[score, dice]
end