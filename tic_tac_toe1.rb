class TicTacToe
  # i is row
  # j is column

  USERS = {"X" => 2, "x" => 2, "0" => 3, 2 => "X", 3 => "0", 0 => "_" }

  def initialize(size, who_first = "0") 
    @current_user = USERS[who_first]
    init_values(size)
  end

  def set(i, j)
    if can_be_set?(i, j)
      @area[i][j] = @current_user

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
      
      return "=============== You are win #{USERS[@current_user]}! =================" if win?(i, j)   
      @current_user = @current_user == 2 ? 3 : 2
      return "Next move #{USERS[@current_user]}"
    end

    "#{i}, #{j} was filled by #{USERS[@area[i][j]]}"
  end

  def print_area
    @area.each { |row| puts row.map{|el| USERS[el]}.join(", ") }
  end

  def win?(i, j)
    sum_mast_be = @current_user*(@size + 1)
    filled_amount_mast_be = @size + 1

    @rows[i][1] == filled_amount_mast_be && @rows[i][0] == sum_mast_be || 
    @columns[j][1] == filled_amount_mast_be && @columns[j][0] == sum_mast_be ||
    @right[1] == filled_amount_mast_be && @right[0] == sum_mast_be || 
    @left[1] == filled_amount_mast_be && @left[0] == sum_mast_be
  end
  
  def can_be_set?(i, j)
    @area[i][j] == 0
  end
  
  def right?(i, check_it)
    @size - i == check_it
  end

  def left?(i, check_it)
    i - check_it == 0
  end

  private

    def init_values(size)
      @area = [[0, 0, 0, 0],
               [0, 0, 0, 0],
               [0, 0, 0, 0],
               [0, 0, 0, 0]
              ]
      @size = @area.size - 1
      #[[sum, filled_amount]]
      @columns = [[0, 0],
                 [0, 0],
                 [0, 0],
                 [0, 0]
                ]
      @rows = [[0, 0], [0, 0], [0, 0], [0, 0]]
      
      @left  = [0, 0]
      @right = [0, 0]
    end
end

#ruby game.rb
tic_tac_toe = TicTacToe.new(4, "0")
loop do
  puts "Set coordinates: "
  puts ""
  coordinates = gets.chomp
  break if coordinates == "exit"
  puts tic_tac_toe.set(*coordinates.split(',').map(&:to_i))

  tic_tac_toe.print_area
end