require './square'
#require './queen.rb'

class RectGrid
  attr_reader :grid, :total_threats

  def initialize(num_rows, num_cols)
    @num_rows, @num_cols = num_rows, num_cols

    # Enumerate the cells in the Grid as an row  x col indexable array
    @grid = []
    (0..num_rows).to_a.each { |n| @grid << (0..num_cols).to_a }

    # Put a new square in each cell
    1.upto(@num_rows) { |r|
      1.upto(@num_cols) { |c|
        @grid[r][c] = Square.new(r, c) 
      }
    }
    
    #Put letters in row 0 and col 0
   start_at = "A"  
   (1..num_rows).to_a.each {|x| @grid[x][0] = start_at; start_at = start_at.next }
   
   start_at = 1
   (1..num_cols).to_a.each {|y| @grid[0][y] = start_at; start_at = start_at.next }
    
#    puts @grid.inspect
    
  end

  def display_grid
    0.upto(@num_rows) { |r|
      0.upto(@num_cols) { |c|
        if r == 0 && c == 0
          print " "
        elsif @grid[r][c].kind_of?(String)
          print @grid[r][c]
        elsif @grid[r][c].kind_of?(Fixnum)
          print "  #{@grid[r][c]}  "
        elsif @grid[r][c].occupant != nil
          print @grid[r][c].occupant
        else  
          @grid[r][c].display_square
        end
      }
      
      puts "\n"
    }
  end
  
  def setup_board
    @queen_hash = {:q1 => [1,1,nil], :q2 => [2,2,nil], :q3 => [3,3,nil], :q4 => [4,4,nil], 
                  :q5 => [5,5,nil], :q6 => [6,6,nil], :q7 => [7,7,nil], :q8 => [8,8,nil] }
    @queen_hash.each_key do |key|
      @queen_hash[key][1] = rand(8) + 1 
      r = @queen_hash[key][0]
      c = @queen_hash[key][1]
      @grid[r][c].occupant = key
    end
  end
  
  def up_threat_count(r,c,row,col)
    unless r == row && c == col
    @threats += 1 if !@grid[r][c].empty? 
    end
  end
  
  def find_threats row, col
    @threats = 0
    (1..8).each do |r|
      (1..8).each do |c| 
        up_threat_count(r,c,row,col) if r == row
        up_threat_count(r,c,row,col) if c == col
        up_threat_count(r,c,row,col) if ((r.to_i-row.to_i).abs == (c.to_i-col.to_i).abs)
      end
    end
    return @threats  
  end
  
  def find_belligerent_queens
    @total_threats = 0
    @most_belligerent = []
    @queen_hash.each_key do |queen|      
      @queen_hash[queen][2] = find_threats @queen_hash[queen][0], @queen_hash[queen][1]
      @total_threats += @queen_hash[queen][2]
      puts "#{queen} threatens #{@queen_hash[queen][2]} other queens"
      if @most_belligerent.empty?
        @most_belligerent << queen
      elsif @queen_hash[queen][2] > @queen_hash[@most_belligerent[0]][2]
        @most_belligerent = [queen]
      elsif @queen_hash[queen][2] == @queen_hash[@most_belligerent[0]][2]
        @most_belligerent << queen
      end
    end
    puts "The most belligerent queen is: #{@most_belligerent}"
    puts "Total Threats (in find_belligerent_queens): #{@total_threats}"
  end  
  
  def pick_move #using find threats needlessly iterates through the entire board???
    queen = @most_belligerent.sample
    r = @queen_hash[queen][0]
    best_move = []
    (1..8).each do |c| 
      best_move << [r,c, find_threats(r,c)] if best_move.empty? || (find_threats(r,c) <= best_move[0][2])
    end
    bm_sample = best_move.sample
    puts "best move is #{bm_sample}"
    @grid[@queen_hash[queen][0]][@queen_hash[queen][1]].occupant = nil
    @total_threats -= (@queen_hash[queen][2]-bm_sample[2])
    @grid[bm_sample[0]][bm_sample[1]].occupant = queen
    @queen_hash[queen][0] = bm_sample[0]
    @queen_hash[queen][1] = bm_sample[1]
    puts "Total threats(in pick_move): #{@total_threats}"
    
  end
  
  def move_cycle
    @move_counter = 0 if @move_counter == nil
    self.find_belligerent_queens
    self.pick_move
    #self.display_grid
    @move_counter += 1
    #puts "Move #{@move_counter}"
  end
  
  
end
