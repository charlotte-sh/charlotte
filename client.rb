class Client
  PORT = 1654

  def initialize(hostname)
    @socket = TCPSocket.open(hostname, PORT)
    handshake
    listen
  end

  def send_packet(channel, **data)
    @socket.puts Packet.new(channel, **data)
  end

  private

  def handshake
    send_packet :handshake, username: Etc.getpwuid(Process.uid).name
  end

  def listen
    begin
      Thread.new do
        loop do
          packet = Packet.parse(@socket.gets.chomp)

          case packet.channel
          when 'handshake'
            puts "Workspace: #{packet.data.dig(:workspace)}"
            puts "Account:   #{packet.data.dig(:username)}"
            puts "Online:    #{packet.data.dig(:machines).join(', ')}"
            puts
          when 'chat'
            puts "#{packet.data.dig(:username)}: #{packet.data.dig(:message)}"
          end
        end
      end
    rescue IOError => e
      puts e.message
      @socket.close
    end
  end
end
