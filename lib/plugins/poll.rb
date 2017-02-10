# Plugin used to create fast polls

module MUCSbot
  module Plugins
    module Poll
      extend Discordrb::Commands::CommandContainer

      Description = 'Creates a poll which ends either when a certain number of votes have been made and/or' +
          'time has elapsed'
      UsageStr = "/poll -args [question];[answer 1];[answer 2];<answer 3>\n-v [number of votes] ... Number of " +
          " votes to end the poll at.\n-t [time in seconds]" +
          "... Time to end the poll at."

      command(:poll,
        description:Description,
        usage:UsageStr,
        min_args: 1) do |event, *text|
        options, question, answers = parseArgs(text)

        if(question.length == 0 || answers.length < 2)
          event.send("You did not provide enough arguments. Type \'/poll\' for usage or see \'/man poll\'.")
        #Comment the next two lines to enable PM usage
        #elsif event::server == nil
        #  event.send("This command cannot be used in PMs. Please see\'/man poll'.")
        else
          #Create poll output
          pollStringBoilerplate = "POLL:\n```Markdown\n" +
              "# Q: #{question}\n"
          answers.each_index do |answerIndex|
            pollStringBoilerplate += "\n\t#{answerIndex}: %ANSWER#{answerIndex}%" +
                "\n\t  > %VOTES#{answerIndex}% votes."
          end
          pollStringBoilerplate += "\n\n# Use '\/vote [OPTION #]' to vote!\n```"

          pollOutput = event.send pollStringBoilerplate
        end
      end

      def self.parseArgs(args)
        #joining arguments passed back into a string to do our own parsing
        joined = args.join(' ')
        #parsing option arguments into the hash
        parsedArgs = {}
        joined.scan(/-\w*\s\w*/).each do |option|
          optionName = option[/(?<=-)\w*\b/] #Get the word immediately following the dash
          #puts optionName, "\n"

          #sets the option param to the value of the option name as a hash key
          parsedArgs["#{optionName}"] = option[/(?<=-#{optionName}\s)\w*/]
        end
        remArgs = joined.gsub(/-\w\s*\w*\s*/, '').split(';')
        remArgs.each {|arg| arg.gsub!(/(?<=^)\s*|\s*(?=$)/, '')} #chop off whitespace at ends

        #Separate out the question
        question = remArgs[0]
        #puts question
        remArgs.delete_at(0)
        #puts remArgs

        return parsedArgs, question, remArgs
      end


    end
  end
end