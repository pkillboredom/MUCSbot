# Gem
require 'discordrb'

#default
require 'yaml'

module MUCSbot
  CONFIG = YAML.load_file('config.yaml')
  bot = Discordrb::Bot.new token: CONFIG['token'], client_id: 276192706412281858

  bot.message(with_text: "Heyo") do |event|
    event.respond 'MUCSbot up!'
  end

  bot.run
end