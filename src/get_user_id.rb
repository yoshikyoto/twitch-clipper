require 'twitch-api'
require 'yaml'

require 'net/http'


config = YAML.load_file("config.yml")
client = Twitch::Client.new(client_id: config["twitch"]["client_id"])
result = client.get_users({login: ARGV[0]})
puts(result.data[0].id)
