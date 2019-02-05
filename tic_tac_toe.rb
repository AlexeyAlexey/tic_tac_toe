class TicTacToe
  # i is row
  # j is column
  # You could replace 3 with "0".bytes[0] 
  # You could replace 2 with "X".bytes[0]
  # You could use "_".bytes[0] instead of 0
  USERS = {"X" => "X", "x" => "X", "0" => "0", "_" => "_" }

  def initialize(dimension, who_first = "0")
    @dimension = dimension
    @current_user = USERS[who_first]
    @current_user_bytes = current_user_bytes #@current_user.bytes[0]

    @board = Array.new(@dimension) {Array.new(@dimension, "_")} #[ ["_", "_", ...], ["_", "_", ...], ...]
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
      @current_user_bytes = current_user_bytes

      @board[i][j] = @current_user

      @rows[i][0] += @current_user_bytes
      @rows[i][1] += 1

      @columns[j][0] += @current_user_bytes
      @columns[j][1] += 1

      if right?(i, j)
        @right[0] += @current_user_bytes
        @right[1] += 1
      end

      if left?(i, j)
        @left[0] += @current_user_bytes
        @left[1] += 1
      end

      @number_of_moves += 1
      
      if check_if_win?(i, j)
        @win = true
        return @win
      else
        @current_user = @current_user == "0" ? "X" : "0"
        return false
      end
    end

    return false
  end

  def who_moves
    @current_user
  end

  def who_win
    @win ? @current_user : "No one"
  end

  def win? 
    @win   
  end

  def game_over?
    @number_of_moves == @dimension**2
  end

  def board
    @board
  end
  
  private
  
    def check_if_win?(i, j)
      sum_mast_be = current_user_bytes*@dimension
      filled_amount_mast_be = @dimension

      @rows[i][1] == filled_amount_mast_be && @rows[i][0] == sum_mast_be || 
      @columns[j][1] == filled_amount_mast_be && @columns[j][0] == sum_mast_be ||
      @right[1] == filled_amount_mast_be && @right[0] == sum_mast_be || 
      @left[1] == filled_amount_mast_be && @left[0] == sum_mast_be
    end
    
    def can_be_set?(i, j)
      @board[i][j] == "_"
    end
    
    def right?(i, check_it)
      @size - i == check_it
    end

    def left?(i, check_it)
      i - check_it == 0
    end

    def current_user_bytes 
      @current_user.bytes[0]
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