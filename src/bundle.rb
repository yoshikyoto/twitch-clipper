require 'yaml'
require './cliper/service'

config = YAML.load_file("config.yml")
service = Cliper::Service.new(config)

# started_at と ended_at により期間を決定
today = Date.today
started_at = today - 14
ended_at = today - 7

service.search_clip_and_download_with_broadcasters(
  config["broadcasters"],
  3,
  started_at,
  ended_at)
