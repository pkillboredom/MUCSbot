# MUCSbot MAIN

#For windows dev. Comment below on release builds.
#::RBNACL_LIBSODIUM_GEM_LIB_PATH = "C:/libsodium/libsodium.dll"

# Gem
require 'discordrb'

#default
require 'yaml'

module MUCSbot
  #Generates config file if one does not exist
  config = File
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

  CONFIG = YAML.load_file('config.yaml')

  config = CONFIG
  VERSIONSTRING = "0.1.0 DEV"
  unless config['version'] == VERSIONSTRING
    puts "WARNING: The version has changed. It is currently up to you to make sure config.yaml is okay.\n"
    config['version'] = VERSIONSTRING
    File.open("config.yaml", "w") { |f| YAML.dump(config, f) }
  end

  #Load classes
  Dir["#{File.dirname(__FILE__)}/*.rb"].each { |file| require file }

  BOT = Discordrb::Commands::CommandBot.new(
      token: CONFIG['token'],
      client_id: 276192706412281858,
      prefix: '/')

  #welcome message for new users
  BOT.member_join do |event|
    newMember = event::member
    if(CONFIG["#{event.server.id}.welcome"] != nil)
      newMember.pm(CONFIG["#{event.server.id}.welcome"])
    else
      puts 'A new member joined but the welcome message is missing.'
    end
  end

  def self.runCommandBot
    #load plugins and require them.
    Commands.include!
    BOT.run
  end

  runCommandBot

end