require 'twitch-api'
require 'yaml'

puts("start")

config = YAML.load_file("config.yml")
client = Twitch::Client.new(client_id: config["twitch"]["client_id"])
result = client.get_clips({broadcaster_id: "104833324"})

result.data.each{ |clip|
    puts(clip.url)
}

puts("end")