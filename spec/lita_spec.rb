require "spec_helper"

describe Lita do
  it "memoizes a Config" do
    expect(described_class.config).to be_a(Lita::Config)
    expect(described_class.config).to eql(described_class.config)
  end

  describe ".clear_events" do
    it "delegates to EventBus.clear" do
      expect(EventBus).to receive(:clear)
      described_class.clear_events
    end
  end

  describe ".configure" do
    it "yields the Config object" do
      described_class.configure { |c| c.robot.name = "Not Lita" }
      expect(described_class.config.robot.name).to eq("Not Lita")
    end
  end

  describe ".publish" do
    it "delegates to EventBus.publish" do
      args = [:foo, :bar, :baz]
      expect(EventBus).to receive(:publish).with(*args)
      described_class.publish(*args)
    end
  end

  describe ".redis" do
    it "memoizes a Redis::Namespace" do
      expect(described_class.redis).to respond_to(:namespace)
      expect(described_class.redis).to eql(described_class.redis)
    end
  end

  describe ".run" do
    before { Lita.config }

    it "runs a new Robot" do
      expect_any_instance_of(Lita::Robot).to receive(:run)
      described_class.run
    end
  end

  describe ".subscribe" do
    it "delegates to EventBus.subscribe" do
      args = [:foo, :bar, :baz]
      expect(EventBus).to receive(:subscribe).with(*args)
      described_class.subscribe(*args)
    end
  end
end
