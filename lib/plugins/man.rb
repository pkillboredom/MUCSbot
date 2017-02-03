module MUCSbot
  module Plugins
    module Man
      extend  Discordrb::Commands::CommandContainer

      DESCRIPTION = 'Tells you about a command!'
      USAGE = "/man [name of command]"
      $manFile = YAML.load_file("#{File.dirname(__FILE__)}/man/man.yaml")
      $manList = "Available listings:"

      command(:man,
        description: DESCRIPTION,
        usage: USAGE,
        min_args: 1,
        max_args: 1) do |event, *text|
        comm_str = text[0]
        begin
          #puts $manFile
          event.send_temp('PMing man page...', 10)
          #puts event.author.id
          manPage = $manFile[comm_str]

          #Parse to human-friendly
          manOut = "```#{comm_str}:\n"
          manPage.each_pair do |key, value|
            #puts key
            puts value
            value.gsub!(/\n\s*^/, "\n\t\t") #Indents only newlines which do not end the value.
            manOut +=  "\t#{key}:\n\t\t#{value}"
          end
          manOut += "```"

          event.author.pm("#{manOut}")
        rescue
          event.send_temp("```markdown\n#Invalid command name.```", 10)
        end
      end

      command(:updateman,
        description: 'Reloads the man file.',
        usage: '/updateman',
        max_args: 0) do |event|
        begin
          updateman
          event.send 'Man file updated.'
        rescue
          event.send 'Man file failed to update.'
        end
      end

      command(:listman,
        description: 'Lists available man files for use with \man',
        usage: '\listman',
        max_args: 0) do |event|
        event.send $manList
      end

      def self.updatelist
        $manList = "Available listings:\n```\n"
        $manFile.each_key do |key|
          #puts key
          $manList += "#{key}\n"
        end
        #$manList.chomp!
        $manList += "```"
        #puts $manList
      end

      def self.updateman
        $manFile = YAML.load_file("#{File.dirname(__FILE__)}/man/man.yaml")
        updatelist
      end

      updatelist

    end
  end
end