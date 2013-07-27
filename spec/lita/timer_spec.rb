require "spec_helper"

describe Lita::Timer do
  let(:queue) { Queue.new }
  let(:fake) do
    fake = double("anything")
    allow(fake).to receive(:call) { queue.push(true) }
    fake
  end

  after { subject.stop }

  describe "#after" do
    it "executes the block after the given delay" do
      subject.after(0) { fake.call }
      expect(queue.pop).to be_true
      expect { queue.pop(true) }.to raise_error
    end
  end

  describe "#every" do
    it "continues executing the block after every interval" do
      subject.every(0) { fake.call }
      2.times { expect(queue.pop).to be_true }
    end
  end

  describe "#stop" do
    it "cancels the timers and kills the thread" do
      subject.every(0) { fake.call }
      subject.stop
      expect_any_instance_of(Thread).to receive(:kill).and_call_original
      expect { queue.pop(true) }.to raise_error
    end
  end
end
