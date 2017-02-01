module MUCSbot
  module Plugins
    module Roll
      extend Discordrb::Commands::CommandContainer
      command(:roll, description: 'Rolls up to 20 dice with up to 100 sides.',
        usage: 'roll <\'# of dice\'d>[# of sides]',
        max_args: 1) do |event, *text|
        if text.nil? || text.length == 0
          event.respond("Rolled a #{rand(1...21)}")
        else
          rollArgs = text[0].split(/[dD]/)
          rollArgs.map! { |var| var.to_i }

          #TODO: Refactor into a switch case
          if rollArgs.length > 2 || rollArgs.length < 0
            event.respond('Invalid Number of Arguments.')
          elsif rollArgs.any?{|rollArg| rollArg < 1}
            event.respond('All arguments must be at least 1.')
          elsif rollArgs.length == 1 && rollArgs[0] <= 100 #Rolling one Die
            max = rollArgs[0] + 1
            event.respond("Rolled a #{rand(1...max)}")
          elsif rollArgs[0] <= 20 && rollArgs[1] <=100 #Rolling many dice
            dice = rollArgs[0]
            max = rollArgs[1] + 1
            rolls = Array.new(dice) {rand(1...max)} #Fill array with dice rolls
            sum = rolls.reduce(:+) #sum the rolls
            output = "Rolled: #{rolls.join(", ")}, totalling #{sum}"
            event.respond(output)
          elsif rollArgs.length == 0 #Roll a d20
            event.respond("Rolled a #{rand(1...21)}")
          else #All other error cases
            event.respond("Syntax error... this message will be more useful some day.")
          end
        end

      end
    end
  end
end