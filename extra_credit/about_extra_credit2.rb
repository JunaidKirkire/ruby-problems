# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.
require_relative 'about_dice_project.rb'
require_relative 'dice_score.rb'

def dice_roll(no_of_die)
  roll_values = []
  no_of_die.times do
    roll_values << rand(1..6)
  end
  roll_values
end

def dice_roll_non_scoring(non_scoring_dice_values)
  puts "non_scoring_dice_values #{non_scoring_dice_values}"
  roll_values = []
  non_scoring_dice_values = (1..6).to_a if non_scoring_dice_values.size == 0
  5.times do
    roll_values << non_scoring_dice_values.sample
  end
  roll_values
end

def ask_for_player_choice(player_no, players)
  puts "Congrats player no. #{player_no + 1}! Your score is now - #{players[player_no].score}"
  if players[player_no].score >= 3000
    "n"
  else
    puts "Do you want to roll again (y/n)"
    players_choice = gets.chomp.downcase
    players_choice
  end
end

class Player
  attr_accessor :score

  def initialize
    @score = 0
  end

  def play_turn(no_of_die = 5)
    no_of_die = 5 if no_of_die == 0 # use all the die
    roll_values = []
    no_of_die.times { roll_values << rand(1..6) }
    roll_values
  end
end

Players = []
is_game_over = false
winning_player_no = -1

puts "Enter the number of players- (cannot be less than 2)"
no_of_players = Integer(gets.chomp)

player_index = (0...no_of_players).to_a.cycle.each # code to cycle through the player's array

#Initialize the players' list
no_of_players.times do
  Players << Player.new
end

#puts score(dice_roll)
#Start the game
loop do
  player_no = player_index.next
  no_of_die = 5
  roll_results = []

  while player_no < no_of_players
    
    if player_no == winning_player_no
      player_no = player_index.next
      next
    end

    dice_roll_values = Players[player_no].play_turn(no_of_die)
    
    puts "Player #{player_no + 1} is rolling now"
    puts "Dice roll values - #{dice_roll_values}"
    roll_results = score2(dice_roll_values)
    dice_score   = roll_results.first
    no_of_die    = roll_results[1].count # no of non-scoring die
    puts "You scored #{dice_score}"

    if dice_score == 0
      Players[player_no].score = 0
      puts "You scored a zero! Sorry, your score has been reset! You loose your turn too!"
      puts # add a new line
      player_no = player_index.next # move to the next player
      no_of_die = 5
      next
    end

    if dice_score >= 300 || Players[player_no].score >= 300
      Players[player_no].score += dice_score
      players_choice = ask_for_player_choice(player_no, Players)

      if players_choice == "y"
          next
      else
        no_of_die = 5
      end
    else
      puts "Sorry Player no. #{player_no + 1}! You need 300 points to start scoring! Try again! Hit [Enter]"
      gets
      next
    end

    is_game_over = true if Players[player_no].score >= 3000

    if Players[player_no].score >= 3000
      is_game_over = true
      winning_player_no = player_no
    end

    player_no = player_index.next

    puts "Press [Enter] to continue"
    gets
  end

  #puts is_game_over
  if is_game_over
    puts "And the winners are -"
    puts Players
    abort("Game over!")
  end
end

