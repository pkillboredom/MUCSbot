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
        res = sounds.find { |x| x.include? file}
        puts res
        unless res.nil?
          event.voice.play_file(res)
          res = nil
        end
      end
    end
  end
end