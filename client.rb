class Client
  PORT = 1654

  attr_reader :connection

  def initialize(hostname)
    @hostname = hostname
    connect
  end

  private

  def connect
    socket = TCPSocket.open(@hostname, PORT)
    @connection = Connection.new socket,
      on_request: -> (message) { on_request(message) },
      on_close: -> (connection) { on_close(connection) }
  end

  def on_request(request)
    case request.channel
    when :chat
      puts "#{request.data.dig(:username)}: #{request.data.dig(:message)}"
    end
  end

  def on_close(connection)
    puts 'Connection closed'
  end
end
