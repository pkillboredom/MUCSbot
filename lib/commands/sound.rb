module MUCSbot
  module Commands
    module Sound
      extend Discordrb::Commands::CommandContainer

      #Constants
      PlayDescription = ""
      PlayUsage = ""

      #Map of playable sound files
      def self.reload_sounds
        $sounds = Dir.glob("#{File.dirname(__FILE__)}/sounds/**/*").select { |f| File.file?(f) }
      end
      $sounds = nil
      reload_sounds

      command(:play,
      description:PlayDescription,
      usage:PlayUsage,
      min_args: 1,
      max_args: 1) do |event, *text|
        file = text[0]
        res = $sounds.find { |x| x.include? file}
        puts res
        unless res.nil?
          event.voice.play_file(res)
          event.voice.stop_playing
          res = nil
        end
      end

      command(:reloadsounds) do |event|
        reload_sounds
        event.send("Sounds reloaded.")
      end

      command(:listsounds) do |event, *text|
        event.send("PMing sounds.")
        event.author.pm($sounds)
      end

      command(:stop) do |event|
        event.voice.stop_playing
      end

    end
  end
end