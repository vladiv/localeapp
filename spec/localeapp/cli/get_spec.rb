require 'spec_helper'
require 'localeapp/cli/get'

describe Localeapp::CLI::Get, "#execute" do
  before do
    @output = StringIO.new
    @getter = Localeapp::CLI::Get.new(:output => @output)
  end

  it "makes the api call to the translations endpoint" do
    with_configuration do
      expect(@getter).to receive(:api_call).with(
        :export,
        :success => :update_backend,
        :failure => :report_failure,
        :max_connection_attempts => anything
      )
      @getter.execute(nil, ['test.data'])
    end
  end
end

describe Localeapp::CLI::Get, "#update_backend(response)" do
  before do
    @test_data = ['test data'].to_json
    @output = StringIO.new
    @getter = Localeapp::CLI::Get.new(:output => @output)
  end

  it "calls the updater" do
    with_configuration do
      allow(Localeapp.poller).to receive(:write_synchronization_data!)
      expect(Localeapp.updater).to receive(:update_by_keys).with(['test data'], nil)
      @getter.update_backend(@test_data)
    end
  end

  it "writes the synchronization data" do
    with_configuration do
      allow(Localeapp.updater).to receive(:update_by_keys)
      expect(Localeapp.poller).to receive(:write_synchronization_data!)
      @getter.update_backend(@test_data)
    end
  end
end
