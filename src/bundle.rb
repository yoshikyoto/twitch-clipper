require 'twitch-api'
require 'yaml'
require 'date'

puts("start")

now = Date.today
a_week_ago = now - 7

config = YAML.load_file("config.yml")
client = Twitch::Client.new(client_id: config["twitch"]["client_id"])
# 直近1週刊のclipを視聴数順に取得
result = client.get_clips({
    broadcaster_id: "104833324",
    started_at: a_week_ago.rfc3339,
    first: 10,
})

result.data.each{ |clip|
    puts(clip.url)
    puts(clip.embed_url)
}

puts("end")