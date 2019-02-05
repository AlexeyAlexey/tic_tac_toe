class TicTacToe
  # i is row
  # j is column
  # You could replace 3 with "0".bytes[0] 
  # You could replace 2 with "X".bytes[0]
  # You could use "_".bytes[0] instead of 0
  USERS = {"X" => 2, "x" => 2, "0" => 3, 2 => "X", 3 => "0", 0 => "_" }

  def initialize(dimension, who_first = "0")
    @dimension = dimension
    @current_user = USERS[who_first]

    @board = Array.new(@dimension) {Array.new(@dimension, 0)} #[ [0, 0, ...], [0, 0, ...], ...]
    @size = @dimension - 1
    
    #[[sum, amount], ...] each element is sum of elements from column
    #sum is sum of elements from column
    #amount is amount of filled elements in a column
    @columns = Array.new(@dimension) {[0, 0]} #[ [[0, 0], [0, 0], ...], [[0, 0], [0, 0], ...], ...]

    #[[sum, amount], ...]
    #sum is sum of elements from row
    #amount is amount of filled elements in a row
    @rows    = Array.new(@dimension) {[0, 0]} #[ [[0, 0], [0, 0], ...], [[0, 0], [0, 0], ...], ...]
    
    #left diagonal (left to right 0,0 -> @size, @size) 
    #sum is sum of elements from diagonal
    #amount is amount of filled elements in a diagonal
    @left  = [0, 0]

    #right diagonal (right to left 0,@size -> @size,0) 
    #sum is sum of elements from diagonal
    #amount is amount of filled elements in a diagonal
    @right = [0, 0]

    @number_of_moves = 0

    @win = false
  end

  def set(i, j)
    if !@win && can_be_set?(i, j)
      @board[i][j] = @current_user

      @rows[i][0] += @current_user
      @rows[i][1] += 1

      @columns[j][0] += @current_user
      @columns[j][1] += 1

      if right?(i, j)
        @right[0] += @current_user
        @right[1] += 1
      end

      if left?(i, j)
        @left[0] += @current_user
        @left[1] += 1
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
    @win ? USERS[@current_user] : "No one"
  end

  def win? 
    @win   
  end

  def game_over?
    @number_of_moves == @dimension**2
  end

  def board
    @board.map{ |row| row.map{|el| USERS[el]} }
  end
  
  private
  
    def check_if_win?(i, j)
      sum_mast_be = @current_user*@dimension
      filled_amount_mast_be = @dimension

      @rows[i][1] == filled_amount_mast_be && @rows[i][0] == sum_mast_be || 
      @columns[j][1] == filled_amount_mast_be && @columns[j][0] == sum_mast_be ||
      @right[1] == filled_amount_mast_be && @right[0] == sum_mast_be || 
      @left[1] == filled_amount_mast_be && @left[0] == sum_mast_be
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

  tic_tac_toe.set(*coordinates.split(',').map(&:to_i))

  tic_tac_toe.board.each { |row| print "#{row.map{|el| el}.join(", ")} \n" }
  
  if tic_tac_toe.win?
    puts "=========== Who win: #{tic_tac_toe.who_win} ==========="
    break
  end

  if tic_tac_toe.game_over?
    print "Game Over \n"
    puts "=========== Who win: #{tic_tac_toe.who_win} ==========="
    break
  end

  print "Who move #{tic_tac_toe.who_moves} \n"
end