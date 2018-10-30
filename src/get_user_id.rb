require 'twitch-api'
require 'yaml'

config = YAML.load_file("config.yml")
client = Twitch::Client.new(client_id: config["twitch"]["client_id"])
result = client.get_users({login: ARGV})
result.data.each{ |user| 
  puts(user.login + ":\t" + user.id)
}
