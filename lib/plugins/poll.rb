# Plugin used to create fast polls

module MUCSbot
  module Plugins
    module Poll
      extend Discordrb::Commands::CommandContainer

      Description = 'Creates a poll which ends either when a certain number of votes have been made and/or' +
          'time has elapsed'
      UsageStr = "/poll -args [question] [answer 1] [answer 2] <answer 3>\nQuestions and answers must be in " +
          "double-quotes.\n-v [number of votes] ... Number of votes to end the poll at.\n-t [time in seconds]" +
          "... Time to end the poll at."

      command(:poll,
        description:Description,
        usage:UsageStr,
        min_args: 3) do |event, *text|
        args = parseArgs(text)
        puts args
      end

      def self.parseArgs(args)
        #joining arguments passed back into a string to do our own parsing
        joined = args.join(' ')
        #parsing option arguments into the hash
        joined.scan(/-.*/).each do |option|
          optionName = option[/(?<=-)\w*\b/] #Get the word immediately following the dash
          parsedArgs["#{optionName}"] = option[/(?<=-#{optionName}\s)\w*/]
        end
        remArgs = joined.sub(/-\w\s*\w*\s*/, '').split(' ')
        return remArgs
      end
    end
  end
end