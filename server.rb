require 'telegram/bot'
require 'yaml'
require_relative 'lib/cta_wrapper'
require_relative 'lib/cta_interactor'

config = YAML.load_file("config.yml")
CTA_TOKEN = config['CTA_TOKEN']
TELEGRAM_TOKEN = config['TELEGRAM_TOKEN']

cta_api = CTAWrapper.new(CTA_TOKEN)
cta_interactor = CTAInteractor.new(cta_api)

Telegram::Bot::Client.run(TELEGRAM_TOKEN) do |bot|
  bot.listen do |message|

    if !message.location.nil?
      location = message.location
      closest_stop  = cta_interactor.get_closest_stop(location.latitude, location.longitude)
      #Get the arrival times not only for the current stop, but all stops at station
      arrival_times = cta_interactor.get_times_for_station(closest_stop[:parent_stop_id]).join("\r\n")
      response_message = "The nearest CTA station is, #{closest_stop[:station_descriptive_name]} \r\n" + arrival_times
      
      bot.api.send_message(chat_id: message.chat.id, text: response_message)
    end

    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    when '/stop'
      bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
    end
  end
end


