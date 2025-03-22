require 'logger'
require 'faraday'
require 'faraday/net_http_persistent'
require 'uri'
require 'facter'
require 'json'
require 'rake/file_utils_ext'

require 'gocd/monitor/cli/api_support'

module Gocd
  module Monitor
    class ApiSupport
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def perform
        options.logger.debug("User arguments — #{options}")
        begin_time = Time.now
        FileUtils.mkdir_p(api_support_dir_name)
        gather_os_facts
        while true
          begin
            options.logger.debug('Making Request To Get GoCD Server Information')
            response = get_server_info
            log_info_to_file(response)
          rescue => e
            options.logger.error(e)
            if begin_time + 10 >= Time.now
              abort(e.message)
            end
          end
          sleep(options.interval.to_i)
        end
      end

      private
      def get_server_info
        response = connection.get
        if response.status == 200
          response
        else
          raise "The server sent an unexpected status code — #{response.status}"
        end
      end

      def gather_os_facts
        options.logger.info 'Gathering facts about this machine'
        File.open(File.join(options.dest_dir, "os-facts.json"), 'w') { |f|
          f.puts JSON.pretty_generate(Facter.to_hash)
        }
      end

      def connection
        @connection ||= begin
          url = File.join(options.go_base_url, 'api/support')
          options.logger.info "Using url: #{url}"
          conn = Faraday.new(url: url) do |conn|
            conn.adapter :net_http_persistent
          end
          if options.username
            conn.request :authorization, :basic, options.username, options.password
          end
          conn
        end
      end

      def log_info_to_file(response)
        time = Time.now.strftime('%Y%m%d_%H%M%S%z')
        filename = File.join(api_support_dir_name, time)
        filename <<  if response.headers['Content-Type'] =~ /\bjson\b/
          ".json"
        else
          ".txt"
        end

        options.logger.debug("Writing log to file - #{filename}")
        File.open(filename, 'w') { |f| f.write(response.body) }
      end

      def api_support_dir_name
        File.join(options.dest_dir, 'api-support')
      end
    end
  end
end
