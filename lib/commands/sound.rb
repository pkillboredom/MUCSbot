module MUCSbot
  module Commands
    module Sound
      extend Discordrb::Commands::CommandContainer

      #Constants
      PlayDescription = ""
      PlayUsage = ""

      #Map of playable sound files
      sounds = Dir.glob("#{File.dirname(__FILE__)}/sounds/**/*")
      puts sounds

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