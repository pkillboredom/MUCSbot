module MUCSbot
  module Plugins
    module Ping
      extend Discordrb::Commands::CommandContainer
      command(:ping, description: 'Sends back a pong!') do
        'Pong!'
      end
    end
  end
end