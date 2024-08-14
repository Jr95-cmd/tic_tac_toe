$grid = "1 2 3\n4 5 6\n7 8 9"
# define classes
class Player
  attr_accessor :player_name, :score, :player_turn, :player_symbol

  def initialize(player_name, score, player_turn, player_symbol)
    @player_name = player_name
    @score = score
    @player_turn = player_turn
    @player_symbol = player_symbol
  end

  def update_grid(move, cur_player)
    grid_arr = $grid.split
    grid_position = grid_arr.find_index(move)
    cur_player.score.push(move.to_i)
    grid_arr[grid_position] = cur_player.player_symbol
    $grid = grid_arr.join(" ")
    puts "#{$grid[0..4]}\n#{$grid[6..10]}\n#{$grid[12..16]}"
  end
end

class Game_Stats
  attr_accessor :winner, :draw, :victor_name

  def initialize(winner, draw, name)
    @winner = winner
    @draw = draw
    @victor_name = name
  end

  def show_win
    @winner
  end

  def check_draw
    @draw
  end
end

file_loc = File.expand_path(__FILE__)
bad_input = "Invalid key!"
Winning_Scores = [[1, 5, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 2, 3], [4, 5, 6], [7, 8, 9], [3, 5, 7]]

active_players = []
puts "Press enter to start"
pressed_key = $stdin.getc
if pressed_key == "\n"
  new_game = Game_Stats.new(nil, nil, nil)
  player = Player.new("player1", [], false, "")
  active_players.push(player)
  puts "Select symbol of choice 'x' or 'o'"
  player.player_symbol = $stdin.getc
  player.player_symbol.downcase!
  case player.player_symbol
  when "x" || "o"
    player2 = Player.new("computer", [], false, "")
    active_players.push(player2)
    player2.player_symbol = case player.player_symbol
                            when "x"
                              "o"
                            else
                              "x"
                            end
    cur_turn = active_players.shuffle!
    cur_turn[0].player_turn = case cur_turn[0].player_name
                              when "player1"
                                true
                              else
                                true
                              end
    puts "\n"

    puts $grid
    while new_game.show_win.nil? && new_game.draw.nil?
      puts "\n"
      if player.player_turn == true
        puts "Select grid position where you would like to place your move"
        $stdin.getc
        move = $stdin.getc
        if $grid.split.include?(move) == false
          puts "#{bad_input}\n"
          puts "#{$grid[0..4]}\n#{$grid[6..10]}\n#{$grid[12..16]}"
        else
          puts "\n"
          player.update_grid(move, player)
          player.player_turn = false
          player2.player_turn = true
        end
      else
        comp_move = $grid.split.sample
        unless %w[x o].include?(comp_move)
          puts "Computer move"
          player2.update_grid(comp_move, player2)
          player2.player_turn = false
          player.player_turn = true
        end
      end

      Winning_Scores.each do |row|
        p1_combo = player.score.combination(3).to_a
        p1_combo.each do |combo|
          combo.sort!
          if combo == row
            puts "\nplayer1 wins"
            new_game.winner = player.player_name
          end
        end
        p2_combo = player2.score.combination(3).to_a
        p2_combo.each do |combo|
          combo.sort!
          if combo == row
            puts "\ncomputer wins"
            new_game.winner = player2.player_name
          end
        end
      end
      x_count = 0
      o_count = 0
      $grid.split.each do |element|
        case element
        when "x"
          x_count += 1
        when "o"
          o_count += 1
        end
      end
      unless x_count + o_count != 9
        new_game.draw = true
        puts "DRAW!"
      end
    end
  else
    puts bad_input
    system("ruby #{file_loc}")
  end
else
  puts bad_input
  system("ruby #{file_loc}")
end
