RSpec.describe Gcp::Api::Discovery::Watcher do
  before do
    @watcher = Gcp::Api::Discovery::Watcher.new
  end

  it "#fetch_discover_api" do
    expect(@watcher.fetch_discover_api("bigquery", "v2")).to be_instance_of(Gcp::Api::Discovery::Watcher::ApiMetadata)
  end
end
