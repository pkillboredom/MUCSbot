# Plugin used to create fast polls

module MUCSbot
  module Commands
    module Poll
      extend Discordrb::Commands::CommandContainer

      Description = 'Creates a poll which ends either when a certain number of votes have been made and/or' +
          'time has elapsed'
      UsageStr = "/poll -args [question];[answer 1];[answer 2];<answer 3>\n-t [time in seconds]" +
          "... Time to end the poll at. Max 180."
      MaxPollTime = MUCSbot::CONFIG['max-poll-time'].to_i

      $pollResponses = {}

      command(:poll,
        description:Description,
        usage:UsageStr,
        min_args: 1) do |event, *text|
        options, question, answers = parseArgs(text)

        begin
          options['t'] = options['t'].to_i unless options['t'].to_i == 0
        rescue
          event.send_temp("Your time option was not an integer.", 10)
        end


        if(question.length == 0 || answers.length < 2)
          event.send("You did not provide enough arguments. Type \'/poll\' for usage or see \'/man poll\'.")
        elsif event::server == nil
          event.send("This command cannot be used in PMs. Please see\'/man poll'.")
        elsif (options['t'] != nil && options['t'].to_i > MaxPollTime)
          event.send_temp("Max option for -t is #{MaxPollTime}. See /man poll.", 10)
        elsif $pollResponses["#{event.server.id}.#{event.channel.id}"] != nil
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

          #turns the response object into a PollResponse
          class << response
            $endTime
            $votes = [nil]
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
              begin
                puts answerNumber
                puts "" << $votes[answerNumber] << "\n"
                $votes[answerNumber] += 1
              rescue
                puts "vote failed on item check\n"
                return false
              end
              if $voters.index(voter) != nil
                puts "vote failed on voter check\n"
                return false
              end
              $stateChanged = true
              $totalVotes += 1
              $voters.push voter
              return true;
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

            #TODO refactor these
            def doRefresh
              #Create poll output
              pollString = "POLL:\n```Markdown\n" +
                  "# Q: #{$question}\n"
              $answers.each_index do |answerIndex|
                if $votes[answerIndex] == nil #Initialize indecies we're using in $votes
                  $votes[answerIndex] = 0
                end
                pollString += "\n\t#{answerIndex}: #{$answers[answerIndex]}" +
                    "\n\t  > #{$votes[answerIndex]} votes."
              end
              pollString += "\n\n# Use '\/vote [OPTION #]' to vote!\n```"
              edit(pollString)
            end
            def endPoll
              #Create poll output
              pollString = "POLL:\n```Markdown\n" +
                  "# Q: #{$question}\n"
              $answers.each_index do |answerIndex|
                if $votes[answerIndex] == nil #Initialize indecies we're using in $votes
                  $votes[answerIndex] = 0
                end
                pollString += "\n\t#{answerIndex}: #{$answers[answerIndex]}" +
                    "\n\t  > #{$votes[answerIndex]} votes."
              end
              pollString += "\n\n# Use '\/vote [OPTION #]' to vote!\n##THIS POLL HAS ENDED##\n```"
              edit(pollString)
            end
          end

          response.setQuestion(question)
          response.setAnswers(answers)
          #Set the end time of the poll. Default 60 sec.
          begin
            #puts options['t']
            response.setEndTime(Time.now + options['t'])
          rescue #Will occur if options['t'] is not set
            response.setEndTime(response.timestamp + 60)
          end
          response.update

          $pollResponses["#{event.server.id}.#{event.channel.id}"] = response

          while response.getEndTime > Time.now
            response.update
            sleep 0.5
          end

          response.endPoll

          #puts "Killing a poll..."
          $pollResponses.delete("#{event.server.id}.#{event.channel.id}")
        end
      end

      command(:vote,
        description: "Votes",
        min_args: 1) do |event, *text|
        poll = $pollResponses["#{event.server.id}.#{event.channel.id}"]

        if poll == nil
          event.send_temp("There is no poll running!", 10)
        else
          answerIndex = text[0].to_i
          #puts answerIndex
          res = poll.incVote(answerIndex, event.author.id)
          if res == false
            puts "INDEX: " << answerIndex.to_s << " AUTHORID: " << event.author.id.to_s << "\n"
            event.send_temp("Either the answer does not exist or you have already voted", 10)
          end
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