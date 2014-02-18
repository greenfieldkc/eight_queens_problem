class Square
  attr_accessor :occupant
  
  def initialize(row,col)
    @row = row
    @col = col
    @occupant = nil
    @color    = :black
    
    set_color
  end 
  
  def empty?
    return true if @occupant == nil
    return false if @occupant != nil
  end
  
  def set_color
    ##if row,col is x,y,z, then color = white else black @color = :black
  end
  
  def display_square
    if @occupant
      @occupant.display_to_screen
    else  
      print " [ ] "
    end
  end
  
end