require 'yaml'
require './cliper/service'

config = YAML.load_file("config.yml")
service = Cliper::Service.new(config)
# started_at と ended_at により期間を決定
started_at = Date.new(2018, 6, 21)
ended_at = Date.new(2018, 6, 23)
service.search_clip_and_download_with_broadcasters(["riotgamesjp"], 20, started_at, ended_at)
