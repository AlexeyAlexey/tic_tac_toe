class TicTacToe
  # i is row
  # j is column
  # You could replace 3 with "0".bytes[0] 
  # You could replace 2 with "X".bytes[0]
  USERS = {"X" => 2, "x" => 2, "0" => 3, 2 => "X", 3 => "0", 0 => "_" }

  def initialize(dimension, who_first = "0")
    @dimension = dimension
    @current_user = USERS[who_first]

    @board = Array.new(@dimension) {Array.new(@dimension, 0)} #[ [0, 0, ...], [0, 0, ...], ...]
    @size = @dimension - 1
    
    #[sum, ...] each element is sum of elements from column
    @columns = Array.new(@dimension, 0) #[0, 0, ...]

    #[sum, ...] each element is sum of elements from row
    @rows    = Array.new(@dimension, 0) #[0, 0, ...]
    
    #it is sum of elements from diagonal (left to right 0,0 -> @size, @size) 
    @left  = 0
    #it is sum of elements from diagonal (right to left 0,@size -> @size,0) 
    @right = 0

    @number_of_moves = 0

    @const_game_over = @dimension**2

    @win = false
  end

  def set(i, j)
    if !@win && can_be_set?(i, j)
      @board[i][j] = @current_user

      @rows[i] += @current_user
      @columns[j] += @current_user

      if right?(i, j)
        @right += @current_user
      end

      if left?(i, j)
        @left += @current_user
      end

      @number_of_moves += 1
      
      if check_if_win?(i, j)
        @win = true
        return @win
      else
        @current_user = @current_user == 2 ? 3 : 2
        return false
      end
    end

    return false
  end

  def who_moves
    USERS[@current_user]
  end

  def who_win
    USERS[@current_user]
  end

  def win? 
    @win   
  end

  def game_over?
    @number_of_moves == @const_game_over
  end

  def board
    @board.map{ |row| row.map{|el| USERS[el]} }
  end
  
  private
  
    def check_if_win?(i, j)
      sum_mast_be = @current_user*(@size + 1)

      @rows[i]    == sum_mast_be || 
      @columns[j] == sum_mast_be ||
      @right      == sum_mast_be || 
      @left       == sum_mast_be 
    end
    
    def can_be_set?(i, j)
      @board[i][j] == 0
    end
    
    def right?(i, check_it)
      @size - i == check_it
    end

    def left?(i, check_it)
      i - check_it == 0
    end
end

#####################################################
#ruby tic_tac_toe.rb
print "Set dimension (integer) NxN: "
dimension = gets.chomp.to_i

print "Who first 'X' or '0': "
first = gets.chomp

tic_tac_toe = TicTacToe.new(dimension, first)
tic_tac_toe.board.each { |row| print "#{row.map{|el| el}.join(", ")} \n" }

print "Who move #{tic_tac_toe.who_moves} \n"
loop do
  print "Set coordinates: \n"

  coordinates = gets.chomp
  break if coordinates == "exit"

  if tic_tac_toe.set(*coordinates.split(',').map(&:to_i))
    puts "=========== Who win: #{tic_tac_toe.who_win} ==========="
  end

  tic_tac_toe.board.each { |row| print "#{row.map{|el| el}.join(", ")} \n" }
  
  tic_tac_toe.win? || tic_tac_toe.game_over? ? break : (print "Who move #{tic_tac_toe.who_moves} \n")
end