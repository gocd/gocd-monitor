require 'optparse'

module Gocd
  module Monitor
    module CLI
      class AnalyzeSupport
        def parse(argv)
          default_options = {
            dest_dir: Dir.pwd,
            log_file: STDERR,
            log_level: Logger::INFO
          }
          options = {}
          OptionParser.new do |opts|
            opts.banner = 'Usage: exe/gocd-monitor-analyze-support [OPTIONS]'

            opts.on('-dDEST', '--destination=DEST', 'Destination directory where logs are stored, defaults to current working directory') do |dest|
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
