#Based on Sapphire_bot
#Adapted under MIT license
#https://github.com/KristupasSavickas/sapphire_bot/blob/master/lib/sapphire_bot/commands.rb
#retrieved Feb 21 2017

module MUCSbot
  module Commands
    Dir["#{File.dirname(__FILE__)}/commands/*.rb"].each {|file| require file}

    @commands = [
        Man,
        Ping,
        Poll,
        Mucsreadme,
        Roll
    ]

    def self.include!
      @commands.each do |command|
        MUCSbot::BOT.include!(command)
      end
    end
  end
end