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

      $pollResponses = {}

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
        elsif $pollResponses["#{event.server.id}.#{event.channel.id}"] == nil
          event.send_temp("There is a poll already running in this channel!", 10)
        else
          #Create poll output
          pollString = "POLL:\n```Markdown\n" +
              "# Q: #{question}\n"
          answers.each_index do |answerIndex|
            pollString += "\n\t#{answerIndex}: #{answers[answerIndex]}" +
                "\n\t  > %VOTES#{answerIndex}% votes."
          end
          pollString += "\n\n# Use '\/vote [OPTION #]' to vote!\n```"

          response = event.respond(pollString)

          class << response #create an anonymous class that has the additional vote params/methods
            $endTime
            $votes = []
            $voters = []
            $totalVotes = 0
            $question = ''
            $answers = {}
            $stateChanged = false

            #Initilization setters
            #TODO replace this with a proper init
            def setQuestion(question)
              $question = question
              $stateChanged = true
            end
            def setAnswers(answers)
              $answers = answers
              $stateChanged = true
            end
            def setEndTime(endTime)
              $endTime = endTime
              $stateChanged = true
            end

            #To be interfaced with by /vote
            def incVote(answerNumber, voter)
              $votes[answerNumber] += 1
              $stateChanged = true
              $totalVotes += 1
              $voters.push voter
            end
            def getVote(answerNumber)
              return $votes[answerNumber]
            end

            #To update the poll results
            def getEndTime
              return $endTime
            end
            def update
              if $stateChanged == true
                doRefresh
                $stateChanged = false
              end
            end
            private :doRefresh
            def doRefresh
              #Create poll output
              pollString = "POLL:\n```Markdown\n" +
                  "# Q: #{$question}\n"
              $answers.each_index do |answerIndex|
                pollString += "\n\t#{answerIndex}: #{$answers[answerIndex]}" +
                    "\n\t  > #{answerIndex} votes."
              end
              pollString += "\n\n# Use '\/vote [OPTION #]' to vote!\n```"
              edit(pollString)
            end
          end

          response.setQuestion(question)
          response.setAnswers(answers)
          #Set the end time of the poll. Default 60 sec.
          begin
            response.setEndTime(options['t'])
          rescue #Will occur if options['t'] is not set
            response.setEndTime(response.timestamp + 60)
          end
          response.update

          $pollResponses["#{event.server.id}.#{event.channel.id}"] = response

          while response.getEndTime > Time.now
            response.update
            sleep .5
          end

          #TODO: Add a message stating that the poll has ended

          $pollResponses.delete("#{event.server.id}.#{event.channel.id}")
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