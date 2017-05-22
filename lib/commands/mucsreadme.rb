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
        if(CONFIG["#{event.server.id}.welcome"] != nil)
          if(text[0] == "mobile")
            event.author..pm(CONFIG["#{event.server.id}.welcome-mobile"])
          else
            event.author.pm(CONFIG["#{event.server.id}.welcome"])
          end
        else
          "A member invoked /welcome but it is not in the config"
        end
      end

      command(:sid, max_args: 0) do |event|
        channels = []
        event.server.channels.each do |channel|
          channels[channel.id] = channel.name
        end
        puts channels
      end
    end
  end
end