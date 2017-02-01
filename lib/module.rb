# module.rb by Shawak
# Used under GPL-3.0 license
# https://github.com/Shawak/mew
# Retrieved Feb 1, 2017

class Module
  def all_the_modules
    [self] + constants.map { |const| const_get(const) }
                 .select { |const| const.is_a?(Module) && !const.is_a?(Class) }
                 .flat_map { |const| const.all_the_modules }
  end
end