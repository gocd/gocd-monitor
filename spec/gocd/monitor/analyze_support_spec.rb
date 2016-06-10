require 'spec_helper'
require 'gocd/monitor/analyze_support'

RSpec.describe Gocd::Monitor::AnalyzeSupport do
  it 'should find long running threads between two snapshots' do
    log_dir = '../../../fixtures/api-support'
    analyze = Gocd::Monitor::AnalyzeSupport.new(OpenStruct.new(dest_dir: File.expand_path(log_dir, __FILE__)))

    renderer = double('renderer')

    options = {
      api_support_hash: JSON.parse(File.read('spec/fixtures/api-support/2016-06-13_12:13:41+0530')),
      api_support_hash_next: JSON.parse(File.read('spec/fixtures/api-support/2016-06-13_12:13:45+0530')),
      thread_id: '951'
    }

    expect(renderer).to receive(:identical_threads).with(options)
    analyze.perform(renderer)
  end
end
