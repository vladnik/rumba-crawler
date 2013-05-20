require "date"
require "json"
require "em-http-request"
require "nokogiri"
require "rumba/crawler/version"
require "rumba/crawler/parser"

module Rumba
  module Crawler

    def self.get_data(url, query)
      EventMachine.run {
        http = EventMachine::HttpRequest.new(url).get query: query
        http.errback { p 'Bad response'; EventMachine.stop }
        http.callback {
          yield(http.response)
          EventMachine.stop
        }
      }
    end
  end
end
