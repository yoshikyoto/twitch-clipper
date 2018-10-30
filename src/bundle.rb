require 'twitch-api'
require 'yaml'
require 'date'
require 'open-uri'
require 'nokogiri'

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
    charset = nil
    html = open(clip.url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)
    puts(doc)
    doc.xpath("//video").each{|t|
        puts(t)
    }

}

puts("end")