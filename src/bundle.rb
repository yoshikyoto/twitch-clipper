require 'twitch-api'
require 'yaml'

puts("start")
config = YAML.load_file("config.yml")
puts(config["twitch"]["client_id"])
