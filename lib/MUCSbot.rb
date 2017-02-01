# Gem
require 'discordrb'

#default
require 'yaml'

module MUCSbot
  cuurentDirectory = "#{File.dirname(__FILE__)}"
  CONFIG = YAML.load_file('config.yaml')
  bot = Discordrb::Bot.new token: CONFIG['token'], client_id: 276192706412281858

  #load plugins and require them.
  plugins["#{currentDirectory}/plugins/*.rb"].each {|pluginFile| require pluginFile}
  plugins.each do |plugin|
    bot.include! plugin
  end

  bot.run
end