require "em-websocket"
require "pp"

connections = []

EM::Websocket.start({:host => {"0.0.0.0"}, :port => 8888}) do |ws_conn|
  ws_conn.onopen do 
    connections << ws_conn
  end

  ws_conn.onmessage do |message|
    pp message
    connections.each {|conn| conn.send(message)}
  end
end