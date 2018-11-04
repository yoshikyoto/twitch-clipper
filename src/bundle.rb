require 'yaml'
require 'date'
require 'open-uri'
require 'twitch-api'
require 'twitch-clipr'

# 現在時刻
now = Time.now.strftime("%Y%m%d%H%M%S")
puts "start: " + now

# dry-runかどうか
is_dry_run = ARGV[0] == "--dry-run"
if is_dry_run
  puts "dry run"
end


config = YAML.load_file("config.yml")
download_dir = config["video"]["download_dir"] + "/" + now
Dir.mkdir(download_dir, 0755)

# twitch api clientの初期化
twitch = Twitch::Client.new(client_id: config["twitch"]["client_id"])

broadcaster_name = "riotgamesjp"

broadcasters = config["broadcasters"]
broadcasters.each { |broadcaster_name|
    # ユーザー名からユーザーIDを引く
    result = twitch.get_users({login: broadcaster_name})
    user = result.data[0]
    puts("name: " + broadcaster_name)
    puts("id: " + user.id)

    # dry-runの場合ユーザーIDを引いて終わり
    if is_dry_run
        continue
    end

    # 1週間前
    today = Date.today
    a_week_ago = today - 7

    # 直近1週間のclipを視聴数順に取得
    result = twitch.get_clips({
        broadcaster_id: user.id,
        started_at: a_week_ago.rfc3339,
        first: 3,
    })

    # クリップをダウンロード
    clip_rank = 1
    result.data.each{ |clip|
        clipr = Twitch::Clipr::Client.new()
        download_url = clipr.get(clip.url)
        puts("downloading: " + clip.url)
        puts("view: " + clip.view_count.to_s)

        # ダウンロードURL resource/今日の日付/配信者名-ClipId.mp4
        download_path = 
            download_dir + "/" + 
            broadcaster_name + "-" + 
            clip_rank.to_s + "-" + 
            clip.view_count.to_s + "views-"
            clip.id + ".mp4"
        clipr.download(download_url, download_path)

        # 負荷軽減のため0.1秒sleep
        sleep(0.1)
    }
}

puts("end")