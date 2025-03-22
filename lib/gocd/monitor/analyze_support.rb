require 'json'
require 'ostruct'

module Gocd
  module Monitor
    class AnalyzeSupport
      attr_reader :options
      def initialize(options)
        @options = options
      end

      def perform(renderer=AnalyzeSupportRenderer.new(options))
        log_files = get_log_files

        log_files.each_cons(2).each do |a, b|
          begin
            api_support_hash = get_hash(a)
            api_support_hash_next = get_hash(b)
          rescue => e
            options.logger.error "An error occured while parsing the logs #{e.message}\n:#{e.backtrace.join("\n")}"
            next
          end

          blocked_threads = get_blocked_threads(api_support_hash)
          blocked_threads_next = get_blocked_threads(api_support_hash_next)

          blocked_threads.each do |thread_id, details|
            same_thread_in_next_snapshot = blocked_threads_next[thread_id]

            next if %w(TIMED_WAITING WAITING).include?(details['State'])
            next unless same_thread_in_next_snapshot

            if details['Stack Trace'] == same_thread_in_next_snapshot['Stack Trace']
              renderer.identical_threads({
                                           api_support_hash: api_support_hash,
                                           api_support_hash_next: api_support_hash_next,
                                           thread_id: thread_id
                                         })
            end
          end
        end
      end

      class AnalyzeSupportRenderer
        attr_reader :options
        def initialize(options)
          @options = options
        end

        def identical_threads(hash)
          api_support_hash = hash[:api_support_hash]
          api_support_hash_next = hash[:api_support_hash_next]
          thread_id = hash[:thread_id]
          details = api_support_hash['Thread Information']['Stack Trace'][thread_id]

          options.logger.info "Found a potential long running thread between snapshots at #{api_support_hash['Timestamp']} and #{api_support_hash_next['Timestamp']}"
          options.logger.info "Thread ID: #{thread_id}"
          options.logger.info "Thread details:\n#{JSON.pretty_generate(details).each_line.collect { |l| "    #{l}" }.join}"
        end
        
      end

      private
      def get_blocked_threads(hash)
        hash['Thread Information']['Stack Trace']
      end

      def get_hash(file_name)
        JSON.parse(File.read(file_name))
      end

      def get_log_files
        Dir[File.join(options.dest_dir, '*')].sort
      end
    end
  end
end
