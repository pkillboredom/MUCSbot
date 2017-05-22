module MUCSbot
  module Commands
    module Sound
      extend Discordrb::Commands::CommandContainer

      #Constants
      PlayDescription = ""
      PlayUsage = ""

      #Map of playable sound files
      sounds = Dir("#{CONFIG['sound']['sound-folder']}/**/*")

      #Connects to voice channels
      CONFIG['sound']['servers'].each do |server|
        begin
          res = BOT.voice_connect(server.channel)
        rescue
          puts("#{server}.#{server.channel} failed to connect. Voice will not work on that server.")
        end
      end

      command(:play,
      description:PlayDescription,
      usage:PlayUsage,
      min_args: 1,
      max_args: 1) do |event, *text|
        file = text[0]
        res = sounds.find(file)
        unless res.nil?
          event.voice.play_file(res)
        end
      end
    end
  end
end