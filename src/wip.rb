
# ゲーム単位でのダウンロード
# 海外のが多いからもうちょっとどうにかしないといけない
game_title = config["game_title"]
game = twitch.get_games({name: game_title})
result = twitch.get_clips({
    game_id: game.id
})
Dir.mkdir(download_dir + "LoL", 0755)
clip_rank = 1
result.data.each{ |clip|
    clipr = Twitch::Clipr::Client.new()
    download_url = clipr.get(clip.url)
    puts("downloading: " + clip.url)
    puts("view: " + clip.view_count.to_s)

    # ダウンロードURL resource/今日の日付/配信者名-ClipId.mp4
    download_path = 
        download_dir + "LoL/" + 
        clip_rank.to_s + "-" + 
        clip.view_count.to_s + "views-"
        clip.id + ".mp4"
    clipr.download(download_url, download_path)

    # 負荷軽減のため0.1秒sleep
    sleep(0.1)
}