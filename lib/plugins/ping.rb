module MUCSbot
  module Plugins
    module Ping
      extend Discordrb::Commands::CommandContainer
      command(:ping, description: 'Sends back a pong!') do |event|
        puts "Ping get"
        response = event.respond('Pong!')
        nil
      end
    end
  end
end