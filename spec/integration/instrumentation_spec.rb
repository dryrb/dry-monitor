# frozen_string_literal: true

RSpec.describe "Subscribing to instrumentation events" do
  subject(:notifications) { Dry::Monitor::Notifications.new(:app) }

  before do
    Dry::Monitor::Notifications.register_event(:sql, name: "rom[sql]")
  end

  describe "#instrument" do
    it "allows subscribing via block" do
      captured = []
      payload = {query: "SELECT 1 FROM users"}

      notifications.subscribe(:sql) do |event|
        captured << [event.id, event[:query]]
      end

      notifications.instrument(:sql, payload)

      expect(captured).to eql([[:sql, "SELECT 1 FROM users"]])
    end

    it "allows instrumenting via block" do
      captured = []
      payload = {query: "SELECT 1 FROM users"}

      notifications.subscribe(:sql) do |event|
        captured << [event.id, event[:query]]
      end

      notifications.instrument(:sql, payload) do
        payload
      end

      expect(captured).to eql([[:sql, "SELECT 1 FROM users"]])
    end

    it "allows instrumenting via block when no payload given" do
      captured = []

      notifications.subscribe(:sql) do |event|
        captured << [event.id]
      end

      notifications.instrument(:sql) {}

      expect(captured).to eql([[:sql]])
    end

    it 'yields the payload to the instrumented block' do
      captured = []

      notifications.subscribe(:sql) do |event|
        captured << event
      end

      notifications.instrument(:sql, outside_block: true) do |payload|
        payload[:inside_block] = true
      end

      expect(captured[0].payload).to match hash_including(
        outside_block: true, inside_block: true
      )
    end
  end
end
