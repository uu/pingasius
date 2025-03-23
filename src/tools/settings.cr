require "log"
require "option_parser"
require "validator"

module Pingasius
  class Settings
    property admin_id = "0"
    property? debug = false
  end

  class Options
    getter settings
    Log = ::Log.for("config")

    def initialize
      @settings = Settings.new

      OptionParser.parse do |opt|
        opt.banner = "pingasius [-d] [-a admin_id]"

        opt.on("-a admin_id", "Admin id") do |admin_id|
          @settings.admin_id = admin_id
        end

        opt.on("-d", "If set, debug messages will be shown.") do
          @settings.debug = true
        end

        opt.on("-h", "--help", "Displays this message.") do
          puts opt
          exit
        end

        opt.on("-v", "--version", "Displays version.") do
          puts VERSION
          exit
        end
      end rescue abort "Invalid arguments, see --help."
    end
  end
end
