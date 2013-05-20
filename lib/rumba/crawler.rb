require "date"
require "json"
require "em-http-request"
require "nokogiri"
require "rumba/crawler/version"
require "rumba/crawler/exceptions"
require "rumba/crawler/models"
require "rumba/crawler/parser"

module Rumba
  module Crawler

    def self.get_data(url, query)
      EventMachine.run {
        http = EventMachine::HttpRequest.new(url).get query: query
        http.errback { raise Exceptions::BadResponse; EventMachine.stop }
        http.callback {
          if http.response_header.status >= 400
            raise Exceptions::BadResponse
          else
            yield(http.response)
          end
          EventMachine.stop
        }
      }
    end
  end
end
