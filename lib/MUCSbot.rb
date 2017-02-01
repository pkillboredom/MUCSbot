# MUCSbot MAIN
# Uses code from mew by Shawak
# See module.rb

# Gem
require 'discordrb'

#default
require 'yaml'

module MUCSbot
  #Load classes
  Dir["#{File.dirname(__FILE__)}/*.rb"].each { |file| require file }

  CONFIG = YAML.load_file('config.yaml')
  BOT = Discordrb::Bot.new token: CONFIG['token'], client_id: 276192706412281858

  def self.run
    #load plugins and require them.
    Dir["#{File.dirname(__FILE__)}/plugins/*.rb"].each {|file| require file}
    (Plugins.all_the_modules-[Plugins]).each do |plugin|
      BOT.include! plugin
    end
    BOT.run
  end

  self.run

end