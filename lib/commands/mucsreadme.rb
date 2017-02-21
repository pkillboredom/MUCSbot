module MUCSbot
  module Commands
    module Mucsreadme
      extend Discordrb::Commands::CommandContainer

      readme = File.open("#{__dir__}/../../README.MD").read

      command(:mucsbot,
        description: "Reads you the README.MD",) do |event|
        event.send_temp("```Markdown\n#{readme}\n```", 60)
      end

      command(:welcome,
        description: "PMs you the Welcome message.",
        usage: '/welcome',
        max_args: 1) do |event, *text|
        if(text[0] == "mobile")
          event.author.pm(CONFIG['welcome-mobile'])
        else
          event.author.pm(CONFIG['welcome'])
        end
      end
    end
  end
end