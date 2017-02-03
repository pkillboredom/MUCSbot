module MUCSbot
  module Plugins
    module Readme
      extend Discordrb::Commands::CommandContainer

      readme = File.open("#{__dir__}/../../README.MD").read

      command(:mucsbot,
        description: "Reads you the README.MD",) do |event|
        event.send_temp("```Markdown\n#{readme}\n```", 60)
      end
    end
  end
end