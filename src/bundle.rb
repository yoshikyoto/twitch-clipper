require 'yaml'
require 'date'
require 'open-uri'
require 'twitch-api'
require 'twitch/clipr'

puts("start")

now = Date.today
a_week_ago = now - 7

config = YAML.load_file("config.yml")
twitch = Twitch::Client.new(client_id: config["twitch"]["client_id"])
# 直近1週間のclipを視聴数順に取得
result = twitch.get_clips({
    broadcaster_id: "104833324",
    started_at: a_week_ago.rfc3339,
    first: 10,
})

result.data.each{ |clip|
    clipr = Twitch::Clipr::Client.new()
    download_url = clipr.get(clip.url)
    puts(clip.url)
    puts(download_url)
}

puts("end")