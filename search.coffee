# Description: A search function for hubot to look for files on a Linux fileserver.
# I use it primarily in Slack with the Slack adapter, but it should work in any chatops scenario.
#
# Dependencies:
# search.sh bash script (included in repository)
#
# Configuration
# You will have to change the path to use the bash script in the "command" variable below.
# You can find the bash script in the repository, but will have to install manually.
#
# Commands:
# hubot search - searches for all terms separated by whitespace as separate arguments
#
# Authors:
# Eric Z Goodnight, with LOTS of help from Evan Soloman & Sapan Ganguly
#

{exec} = require 'child_process'
module.exports = (robot) ->
  robot.respond /super[\s]?search (.*)$/i, (msg) ->
    Argument = msg.match[1]
    command = "./search.sh '#{Argument}' "
    msg.send "Searching for #{Argument}."

    exec command, (error, stdout, stderr) ->

      if stdout
        msg.send stdout

      else
        msg.send "Cannot find it!"
