class Computer
  attr_reader :best_move

  def initialize(player_token, computer_token, board)
    @player_token = player_token
    @computer_token = computer_token
    @best_move = -1
    @initial_state = board.contents
    @board = board
  end

  def best_move
    current_token = @computer_token
    child_states = get_next_gen_states(@initial_state,current_token)
    child_scores = get_next_gen_scores(child_states,current_token)
    puts "child_states"
    puts child_states.inspect
    for index in 0...child_states.size
      if child_scores[index] == 0
        child_scores[index] = sum_leaf_scores(child_states[index],current_token)
      end
    end

    puts"child_scores"
    puts child_scores.inspect

    best_move_index = 0
    for index in 1...child_scores.size
      if child_scores[index] > child_scores[best_move_index]
        best_move_index = index
      end
    end

    initial_moves = get_current_token_moves(@initial_state,current_token)
    best_state = child_states[best_move_index]
    best_moves = get_current_token_moves(best_state,current_token)
    if best_moves.size > 1
      best_move = get_most_recent_move(initial_moves,best_moves)
    else
      best_move = best_moves.pop
    end
    return best_move
  end

def get_next_gen_states(current_state,current_token)
    next_gen_states = []
    current_state.each do |value|
      if value != "X" && value != "O"
        possible_state = current_state.map { |index| index == value ? current_token : index }
        next_gen_states << possible_state
      end
    end
    return next_gen_states
  end

  def get_next_gen_scores(next_gen_states,current_token)
    next_gen_scores = []
    next_gen_states.each do |next_gen_state|
      current_token_moves = get_current_token_moves(next_gen_state,current_token)
      if @board.is_game_over?(current_token_moves)
        if current_token == @computer_token
          next_gen_scores << 1
        else
          next_gen_scores << -1
        end
      else
        next_gen_scores << 0
      end
    end
    return next_gen_scores
  end

  def get_current_token_moves(current_state,current_token)
    current_token_moves = []
    for index in 0...current_state.size
      if current_state[index] == current_token
        current_token_moves << index.to_s
      end
    end
    return current_token_moves
  end

  def get_most_recent_move(previous_token_moves,current_token_moves)
    most_recent_move = 0
    current_token_moves.each do |move_index|
      unless previous_token_moves.include?(move_index)
        most_recent_move = move_index
        break
      end
    end
    return most_recent_move
  end

  def switch_token(current_token)
    if current_token == "X"
      new_token = "O"
    else
      new_token = "X"
    end
    return new_token
  end

  def sum_leaf_scores(current_state,current_token)
    sum_leaf_scores = 0
    current_token = switch_token(current_token)
    unless @board.is_tie?(current_state)
      next_gen_states = get_next_gen_states(current_state,current_token)
      # puts "next_gen_states"
      # puts next_gen_states.inspect
      next_gen_scores = get_next_gen_scores(next_gen_states,current_token)
      for index in 0...next_gen_states.size
        if next_gen_scores[index] == 0
          next_gen_score = sum_leaf_scores(next_gen_states[index],current_token)
          # if next_gen_scores.index(0)
          # next_gen_scores[next_gen_scores.index(0)] = next_gen_score
          # end
          next_gen_scores.map! { |x| x == 0 && next_gen_scores.index(x) == index ? next_gen_score : x }
        end
      end
      # puts "end of branch gen scores (should = 1, -1, or 0)"
      # puts next_gen_scores.inspect
      sum_leaf_scores = next_gen_scores.inject(:+)
    end
    return sum_leaf_scores
  end

end
