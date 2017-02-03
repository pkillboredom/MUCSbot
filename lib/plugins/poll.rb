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
              description:@description,
              usage:@usage,
              min_args: 3) do |event, *text|
      end
    end
  end
end