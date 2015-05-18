class Board
  attr_accessor :contents, :game_over, :player_moves, :computer_moves

  def initialize
    @winning_cases = [
    ["0","1","2"],
    ["3","4","5"],
    ["6","7","8"],
    ["0","3","6"],
    ["1","4","7"],
    ["2","5","8"],
    ["0","4","8"],
    ["6","4","2"]
    ]
    @contents = ("0".."8").to_a
    @player_moves = []
    @computer_moves = []
  end

  def display
    for m in 0...@contents.size
        if m % Math.sqrt(@contents.size) == 0
          puts "\n ___________"
          print "| "
        end
        print @contents[m] , " | "
    end
    puts "\n ___________"
  end

  def is_game_over?(moves)
    game_over = false
    @winning_cases.each do |winning_case|
      match_count = 0
      moves.each do |move|
        if winning_case.include?(move)
          match_count += 1
        end
      end
      if match_count >= winning_case.size
        game_over = true
      end
    end
    game_over
  end

  def is_tie?(state)
    is_tie = false
    state.each.with_index do |value, index|
      if value != "X" && value != "O"
        break
      end
      if index == state.size - 1
      is_tie = true
      end
    end
    is_tie
  end

end
