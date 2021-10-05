require "rubygems"
require "em-websocket"

MAX_LOG = 100

EM::run do
  @channel = EM::Channel.new
  @log = Array.new
  @channel.subscribe{|mes|
    @logs.push mes
    @logs.shift if @logs.size > MAX_LOG
  }

  EM::Websocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen{
      sid = @channel.subscribe{|mes|
        ws.send(mes)
      }

      ws.onmessage{ |mes|
        @channel.push(mes)
      }

      ws.onclose {
        @channel.unsubscribe(sid)
        @channel.push("disconnect")
      }
    }
  end

  EM::defer do
    loop do
      @channel.push Time.now.to_s
      sleep 15
    end
  end
end