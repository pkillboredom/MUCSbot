module MUCSbot
  module Commands
    module Sound
      extend Discordrb::Commands::CommandContainer

      #Constants
      PlayDescription = ""
      PlayUsage = ""

      #Map of playable sound files
      sounds = Dir.glob("sounds/**/*")
      puts CONFIG['sound']['sound-folder']
      puts sounds

=begin
      #Connects to voice channels
      servers = MUCSbot::BOT.servers
      CONFIG['sound']['servers'].each do |serverid|

        #try to find the server
        the_server = nil
        servers.each do |server|
          if server.id == serverid
            the_server = server
          end
        end

        #try to find the channel
        the_channel = nil
        the_server.channels.each do |channel|
          if channel.id == serverid['channel']
            the_channel = channel
          end
        end

        begin
          res = MUCSbot::BOT.voice_connect(the_channel)
        rescue
          puts("#{serverid}.#{serverid['channel']} failed to connect. Voice will not work on that server.")
        end
      end
=end

      command(:play,
      description:PlayDescription,
      usage:PlayUsage,
      min_args: 1,
      max_args: 1) do |event, *text|
        file = text[0]
        res = sounds.find { |x| i.include? file}
        puts res
        unless res.nil?
          puts "./#{res}"
          event.voice.play_file("./#{res}")
        end
      end
    end
  end
end