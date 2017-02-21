# MUCSbot MAIN
# Uses code from mew by Shawak
# See module.rb

# Gem
require 'discordrb'

#default
require 'yaml'

module MUCSbot
  #Generates config file if one does not exist
  unless File.exists?('config.yaml')
    begin
      default_config = File.open('example-config.yaml')
      config = File.new('config.yaml', 'w')
      config.write(default_config)
    rescue
      abort("There is no config.yaml and one could not be made from example-config.yaml\n" +
        "Please download a clean copy of MUCSbot or check your permissions.")
    end
  end

  #Load classes
  Dir["#{File.dirname(__FILE__)}/*.rb"].each { |file| require file }

  CONFIG = YAML.load_file('config.yaml')

  BOT = Discordrb::Commands::CommandBot.new(
      token: CONFIG['token'],
      client_id: 276192706412281858,
      prefix: '/')

  BOT.member_join do |event|
    newMember = event::member
    begin
      newMember.pm(CONFIG['welcome'])
    rescue
      puts 'A new member joined but the welcome message is missing'
    end
  end

  def self.runCommandBot
    #load plugins and require them.
    Commands.include!
    BOT.run
  end

  runCommandBot

end