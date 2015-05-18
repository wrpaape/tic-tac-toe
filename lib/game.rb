require_relative 'board'
require_relative 'computer'

class Game
  attr_reader :player_token, :computer_token

  @prompt = " >"

  def initialize
    @board = Board.new
  end

  def start
    display_header

    puts("\nWould you like to play as X's (x) or O's (o)?#{@prompt}")
    @player_token = gets.chomp.upcase
    if @player_token == "X"
      @computer_token = "O"
    elsif @player_token == "O"
      @computer_token = "X"
    else
      start
    end

    @computer = Computer.new(@player_token,@computer_token,@board)

    loop do
      player_turn
      if @board.is_game_over?(@board.player_moves); break end
      sleep(0.5)
      computer_turn
      if @board.is_game_over?(@board.computer_moves); break end
    end

    game_over

  end

  def player_turn
    display_header
    @board.display
    puts("\nSelect your move (0-8)#{@prompt}")
    @player_move = gets.chomp.to_i
    @board.player_moves << @player_move.to_s
    @board.contents[@player_move].replace(@player_token)
  end

  def computer_turn
    @computer_move = @computer.best_move
    @board.computer_moves << @computer_move.to_s
    @board.contents.map! { |x| x == @computer_move ? @computer_token : x }
    puts "*******"
    puts @computer_move
    display_header
    @board.display
  end

  def display_header
    system("clear")
    puts("******************************************")
    puts("************* Welcome to... **************")
    puts("******************************************")
    puts("************** TIC-TAC-TOE ***************")
    puts("******************************************")
    puts("************* by Reid Paape **************")
    puts("******************************************")
  end

  def game_over
    display_header
    @board.display
    puts "\nGAME OVER"
  end

end
