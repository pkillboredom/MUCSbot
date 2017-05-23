module MUCSbot
  module Commands
    module Sound
      extend Discordrb::Commands::CommandContainer

      #Constants
      PlayDescription = ""
      PlayUsage = ""

      $sounds = nil
      $sound_list = []
      #Map of playable sound files
      def self.reload_sounds
        $sounds = Dir.glob("#{File.dirname(__FILE__)}/#{CONFIG['sound']['sound-folder']}/**/*").select { |f| File.file?(f) }
        $sounds = $sounds.sort
        page_counter = 0
        item_counter = 0
        $sound_list = []
        $sound_list[0] = []
        $sounds.each do |x|
          unless item_counter >= 10
            $sound_list[page_counter][item_counter] = "#{File.expand_path(x)[/(?<=#{CONFIG['sound']['sound-folder']}\/).*$/]}"
            item_counter += 1
          else
            item_counter = 0
            page_counter += 1
            $sound_list[page_counter] = []
          end
        end
      end
      reload_sounds

      command(:play,
              description:PlayDescription,
              usage:PlayUsage,
              min_args: 1,
              max_args: 2) do |event, *text|
        if text[1].nil?
          file_input = text[0]
          search_result = $sounds.grep(/(?<=#{CONFIG['sound']['sound-folder']}\/).*#{file_input}.*/i)
          res = nil
          if search_result.length > 1
            if search_result.length > 15
              event.send("Search not specific enough. Please try narrowing your query.")
            else
              string_to_send = "Please append a selection to your command to select\n" +
                  "e.g. /play #{file_input} 2\n```"
              counter = 1
              selector = {}
              search_result.each do |x|
                selector[counter] = x
                string_to_send += "#{counter}) #{File.expand_path(x)[/(?<=#{CONFIG['sound']['sound-folder']}\/).*$/]}\n"
                counter += 1
              end
              string_to_send += '```'
              event.send(string_to_send)
            end
          else
            res = search_result.first
          end
          puts res
          unless res.nil?
            puts "Hitting play as lone file"
            event.voice.play_file(res)
            event.voice.stop_playing
            res = nil
          end
        else
          file_input = text[0]
          arg1 = text[1].to_i
          search_result = $sounds.grep(/(?<=#{CONFIG['sound']['sound-folder']}\/).*#{file_input}.*/i)
          res = nil
          if search_result.length > 0
            if search_result.length > 15
              event.send("Search not specific enough. Please try narrowing your query.")
            else
              counter = 1
              selector = {}
              search_result.each do |x|
                selector[counter] = x
                counter += 1
              end
              res = selector[arg1]
            end
          else
            event.send("Your second argument was invalid.")
          end
          puts res
          unless res.nil?
            puts "Hitting play as a selector"
            event.voice.play_file(res)
            event.voice.stop_playing
            res = nil
          end
        end
      end

      command(:reloadsounds) do |event|
        reload_sounds
        event.send("Sounds reloaded.")
      end

      command(:listsounds) do |event, *text|
        event.send("PMing sounds.")
        unless text[0].nil?
          string_to_pm = '```'
          $sound_list[text[0].to_i].each {|x| string_to_pm += "#{x}\n"}
          string_to_pm += '```'
          event.author.pm(string_to_pm)
        else
          string_to_pm = '```'
          $sound_list[0].each {|x| string_to_pm += "#{x}\n"}
          string_to_pm += '```'
          event.author.pm(string_to_pm)
        end
      end

      command(:stop) do |event|
        event.voice.stop_playing
      end

    end
  end
end