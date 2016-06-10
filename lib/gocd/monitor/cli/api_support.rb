require 'optparse'
require 'ostruct'

module Gocd
  module Monitor
    module CLI
      class ApiSupport
        def parse(argv)
          default_options = {
            interval: 10,
            dest_dir: Dir.pwd,
            log_file: STDERR,
            log_level: Logger::INFO
          }
          options = {}
          OptionParser.new do |opts|
            opts.banner = 'Usage: exe/gocd-monitor-api-support [OPTIONS]'

            opts.on('-sURL', '--server-url=URL', 'GoCD Server URL (https://example.com:8154/go)') do |url|
              options[:go_base_url] = url
            end

            opts.on('-uUSERNAME', '--username=USERNAME', 'Username to use to login to the server (must be an admin)') do |username|
              options[:username] = username
            end

            opts.on('-pPASSWORD', '--password=PASSWORD', "The password") do |password|
              options[:password] = password
            end

            opts.on('-iINTERVAL', '--interval=INTERVAL', 'Time interval in seconds to run monitor activity') do |t|
              options[:interval] = t
            end

            opts.on('-dDEST', '--destination=DEST', 'Destination directory to store logs, defaults to current working directory') do |dest|
              options[:dest_dir] = dest
            end

            opts.on('-LLOG_FILE', '--log-file=LOG_FILE', 'The log file, defaults to STDERR') do |logfile|
              options[:log_file] = logfile
            end

            opts.on('-lLEVEL', '--log-level=LEVEL', "The log level. Valid values are #{Logger::Severity.constants.collect(&:downcase).collect(&:to_s).join(' ')}") do |level|
              options[:log_level] = Logger::Severity.const_get(level.upcase.to_sym)
            end

            opts.on_tail('-h', '--help', 'Show this message and exit') do
              puts opts
              exit
            end

            # Another typical switch to print the version.
            opts.on_tail('-v', '--version', 'Show version and exit') do
              puts Gocd::Monitor::VERSION
              exit
            end
          end.parse!(argv)

          options = default_options.merge(options)

          options[:logger] = Logger.new(options.delete(:log_file))
          options[:logger].level = options.delete(:log_level)

          OpenStruct.new(options)
        end
      end
    end
  end
end
