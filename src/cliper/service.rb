require 'date'
require 'twitch-api'
require 'twitch-clipr'

module Cliper
  class Service
    def initialize(config)
      @config = config
      @twitch = Twitch::Client.new(client_id: config["twitch"]["client_id"])
      @clipr = Twitch::Clipr::Client.new()
    end

    def search_clip_and_download_with_broadcasters(
        broadcasters, 
        clips_count_each,
        started_at,
        ended_at)
      now = Time.now.strftime("%Y%m%d%H%M%S")
      puts "start: " + now

      # ダウンロード先のディレクトリを作成
      download_dir = @config["video"]["download_dir"] + "/" + now
      Dir.mkdir(download_dir, 0755)
      
      # started_at と ended_at により期間を決定
      today = Date.today
      started_at = today - 14
      ended_at = today - 7

      broadcasters.each { |broadcaster_name|
        # ユーザー名からユーザーIDを引く
        result = @twitch.get_users({login: broadcaster_name})
        user = result.data[0]
        puts("name: " + broadcaster_name)
        puts("id: " + user.id)

        # 直近1週間のclipを視聴数順に取得
        result = @twitch.get_clips({
          broadcaster_id: user.id,
          started_at: started_at.rfc3339,
          ended_at: ended_at.rfc3339,
          first: clips_count_each,
        })

        # クリップをダウンロード
        result.data.each{ |clip|
          download_url = @clipr.get(clip.url)
          puts("downloading: " + clip.url)
          puts("view: " + clip.view_count.to_s)

          # ダウンロードURL resource/今日の日付/配信者名-ClipId.mp4
          download_path = 
            download_dir + "/" + 
            broadcaster_name + "-" + 
            clip.view_count.to_s + "views-" +
            clip.id + ".mp4"
          @clipr.download(download_url, download_path)

          # 負荷軽減のため0.1秒sleep
          sleep(0.1)
        }
      }
      puts("end")
    end
  end
end