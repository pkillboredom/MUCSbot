module MUCSbot
  module Commands
    module Sound
      extend Discordrb::Commands::CommandContainer

      #Constants
      PlayDescription = ""
      PlayUsage = ""

      #Map of playable sound files
      sounds = Dir.glob("#{File.dirname(__FILE__)}/sounds/**/*").select { |f| File.file?(f) }
      puts sounds

      command(:play,
      description:PlayDescription,
      usage:PlayUsage,
      min_args: 1,
      max_args: 1) do |event, *text|
        file = text[0]
        res = sounds.find { |x| x.include? file}
        puts res
        unless res.nil?
          puts "hit, next is play..."
          event.voice.play_file(res)
          event.voice.stop_playing
          res = nil
        end
      end
    end
  end
end