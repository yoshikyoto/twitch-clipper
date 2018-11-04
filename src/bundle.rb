require 'yaml'
require 'date'
require 'open-uri'
require 'twitch-api'
require 'twitch-clipr'


now = Time.now.strftime("%Y%m%d%H%M%S")
puts "start: " + now

today = Date.today
a_week_ago = today - 7

config = YAML.load_file("config.yml")
download_dir = config["video"]["download_dir"] + "/" + now
Dir.mkdir(download_dir, 0755)

twitch = Twitch::Client.new(client_id: config["twitch"]["client_id"])

broadcaster_name = "riotgamesjp"

# ユーザー名からユーザーIDを引く
result = twitch.get_users({login: broadcaster_name})
user = result.data[0]

# 直近1週間のclipを視聴数順に取得
result = twitch.get_clips({
    broadcaster_id: user.id,
    started_at: a_week_ago.rfc3339,
    first: 1,
})

# クリップをダウンロード
result.data.each{ |clip|
    clipr = Twitch::Clipr::Client.new()
    download_url = clipr.get(clip.url)
    download_path = download_dir + "/" + broadcaster_name + "-" + clip.id + ".mp4"
    clipr.download(download_url, download_path)
    sleep(0.1)
}

puts("end")