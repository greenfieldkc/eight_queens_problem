require './rect_grid.rb'

class GameTracker

  def initialize
    @wins = 0
  end
  
  def run_game
    board = RectGrid.new 8, 8
    board.setup_board
    puts "Original board is:"
    board.display_grid
    100.times do |x| 
      if board.total_threats == 0
        @wins += 1
        break
      else
        board.move_cycle
      end
    end
  end

  def n_games num_games
    num_games.times do |game|
      run_game
    end
    puts "wins: #{@wins}"
  end
end
#game = GameTracker.new
#game.n_games 1000

board = RectGrid.new 8,8
board.setup_board
board.display_grid

#tested with 1000 games and returned 305 wins, or 30.5%, second test returned 333 wins, or 33.3%
