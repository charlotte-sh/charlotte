class Client
  PORT = 1654

	def initialize(hostname)
		@socket = TCPSocket.open(hostname, PORT)
    handshake
    listen_response
	end

	def send(message)
		begin
      @socket.puts message
		rescue IOError => e
			puts e.message
			@socket.close
		end
	end

  private

  def handshake
    name = "#{Etc.getlogin}@#{Socket.gethostbyname(Socket.gethostname).first}"
    @socket.puts name
  end

	def listen_response
		begin
			Thread.new do
				loop do
					response = @socket.gets.chomp
					puts "#{response}"
				end
			end
		rescue IOError => e
			puts e.message
			@socket.close
		end
	end
end
