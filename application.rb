class Application
  def run
    display_banner
    start_client
    authenticate
    start_tmate
    start_prompt
  end

  private

  def display_banner
    puts
    puts '   ________               __      __  __     v0.0'
    puts '  / ____/ /_  ____ ______/ /___  / /_/ /____     '
    puts ' / /   / __ \/ __ `/ ___/ / __ \/ __/ __/ _ \    '
    puts '/ /___/ / / / /_/ / /  / / /_/ / /_/ /_/  __/    '
    puts '\____/_/ /_/\__,_/_/  /_/\____/\__/\__/\___/     '
    puts
  end

  def start_client
    @username, @hostname = ARGV.first.split('@')
    @client = Client.new(@hostname)
  end

  def authenticate
    @client.connection.request :authentication, username: @username do |response|
      workspace = response.data.dig(:workspace)
      puts "#{@username}@#{workspace} $"
      puts
    end
  end

  def start_tmate
    webhook_url = "https://#{@hostname}:1913"
    webhook_id = @username

    tmate_config = Tempfile.new('tmate')
    tmate_config.puts <<~CONFIG
      set-option -g tmate-webhook-url "#{webhook_url}"
      set-option -g tmate-webhook-userdata "#{webhook_id}"
    CONFIG
    tmate_config.flush

    tmate_path = 'tmate'
    tmate_config_path = tmate_config.path
    Open3.popen3("#{tmate_path} -F -f #{tmate_config_path}")
  end

  def start_prompt
    while input = Readline.readline('', true)
      if input.start_with? '/'
        params = input.delete_prefix('/').split
        command = params.shift

        case command
        when 'machines'
          @client.connection.request(:machines) do |response|
            machines = response.data.dig(:machines)
            puts machines.join(', ')
          end

        when 'connect'
          @client.connection.request(:shell, username: params.first)
        end
      else
        @client.connection.request(:chat, message: input) unless input.empty?
      end
    end
  end
end
