class HumanPlayer 
    def make_guess
        guess = []
    puts "\n=== Make Your Guess ===\n"
    4.times do |position|
        color = select_colors
        puts "\nYou chose color #{color} at position #{position + 1}"
        guess << color
    end
    puts "\nYour guess is: #{guess.join(", ")}"
    guess
    end

    def make_guess_play(secret_code)
    turns = 1
    begin
        if turns == 1
            puts "\nCan you guess the secret code? The right colors, in the right order."
            guess = make_guess
        else
            puts "\nYou didn't guess the code yet! #{13 - turns} guesses remaining"
            guess = make_guess
        end
        turns += 1
        Feedback.give_feedback(guess, secret_code)
    end while guess != secret_code && turns <= 12
    
    if guess == secret_code
        puts "\nCongratulations! You've guessed the code: #{guess.join(", ")}"
    else
        puts "\nOut of turns! The secret code was #{secret_code.join(", ")}. Better luck next time!"
    end
    end

    def create_code
        secret_code = []
    puts "\n=== Make Your Secret Code ===\n"
    4.times do |position|
        color = select_colors
        puts "\nYou chose color #{color} at position #{position + 1}"
        secret_code << color
    end
    puts "\nYour secret code is: #{secret_code.join(", ")}"
    secret_code
    end

    def select_colors
        color_choices = ["Red", "Green", "Blue", "Yellow", "Orange", "Pink"]
        color = nil
        until color_choices.include?(color)
            puts "\nColor Choices: #{color_choices.join(", ")}"
            print "Enter a color: "
            color = gets.chomp().capitalize()
            unless color_choices.include?(color)
                puts "\nInvalid choice. Try again."
            end   
        end
        color
    end

end

class ComputerPlayer
    def make_guess_play(secret_code)
        turns = 1
    guess = nil
    color_choices = ["Red", "Green", "Blue", "Yellow", "Orange", "Pink"]
    deleted_colors = []
    
    begin
        guess_pool = color_choices - deleted_colors

        guess = Array.new(4) { guess_pool.sample }
        
        correct_color_and_position, correct_color_not_position = Feedback.give_feedback(guess,secret_code)
        
        if guess == secret_code
            puts "Computer guesses correctly, code is #{guess.join(", ")}"
            break
        else
            puts "Computer guesses incorrectly, code is not #{guess.join(", ")}"
        end

        if correct_color_and_position == 0 && correct_color_not_position == 0
            guess.each do |color|
                unless deleted_colors.include?(color)
                    deleted_colors << color
                end
            end  
        end

        turns += 1
    end while guess != secret_code && turns <= 12      

    end

    def create_code
        color_choices = ["Red", "Green", "Blue", "Yellow", "Orange", "Pink"]
    code_length = 4
    codemaker = Array.new(4) {color_choices.sample}
    end
end

class Feedback
    def self.give_feedback(guess,secret_code)
        correct_color_and_position = 0
        correct_color_not_position = 0
    
        guess_clone = guess.clone
        secret_code_clone = secret_code.clone
    
        guess.each_with_index do |guess_color, index|
            if guess_color == secret_code[index]
                correct_color_and_position += 1
                guess_clone[index]=nil
                secret_code_clone[index]=nil
            end
        end
    
        guess_clone.each_with_index do |guess_color, index|
            next if guess_color.nil?
            if secret_code_clone.include?(guess_color)
                correct_color_not_position += 1
                marked_index = secret_code_clone.index(guess_color)
                secret_code_clone[marked_index] = nil
                guess_clone[index] = nil
            end
        end
        puts "\n=== Feedback ===\n\n"
        puts "Correct Color and Position: #{correct_color_and_position}"
        puts "Correct Color and Incorrect Position: #{correct_color_not_position}"
        [correct_color_and_position, correct_color_not_position]
    end
end

class Game
    def initialize
        @codemaker = nil
        @codebreaker = nil
        @secret_code = nil
    end

    def role_selection
        possible_answers = ["1","2"]
    puts "\n Select: (1) Create secret code || (2) Guess secret code"
    user_role = gets.chomp()
    until possible_answers.include?(user_role)
        puts "\n Incorrect. Select: (1) Create secret code || (2) Guess secret code"
        user_role = gets.chomp()
    end
    user_role
    end

    def assign_roles(user_role)
        if user_role == "1"
            @codemaker = HumanPlayer.new()
            @secret_code = @codemaker.create_code
            @codebreaker = ComputerPlayer.new()
            @codebreaker.make_guess_play(@secret_code)
        elsif user_role == "2"
            @codemaker = ComputerPlayer.new()
            @secret_code = @codemaker.create_code
            @codebreaker = HumanPlayer.new()
            @codebreaker.make_guess_play(@secret_code)
        end
    end

    def start_game
        user_role = role_selection
        assign_roles(user_role)
    end
end

game = Game.new()
game.start_game
