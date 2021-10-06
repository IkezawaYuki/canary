require "faye/websocket"
require "eventmachine"

ws = Faye::Websocket::Client.new("ws://localhost:8080")

EM.run {
  ws.on :open do |event|
    ws.send("Hello, world")
  end

  ws.on :message do |event|
    puts event.data
  end

  ws.on :close do |event|
    puts "CLOSE: code=#{event.code} reason=#{event.reason}"
  end

  ws.on :error do |error|
    puts "ERROR: #{error}"
  end

  EM.defer {
    ws.send STDIN.gets.strip
  }
}