require 'spec_helper'

module Rumba
  module Crawler
    describe '#get_data' do
      it "makes GET request to specified url with specified parameters" do
        stub = stub_request(:get, "http://example.com/?date=now").to_return(status: 200, body: '', headers: {})
        Rumba::Crawler.get_data('http://example.com', {date: 'now'}) { |response| }
        stub.should have_been_requested
      end

      it "invokes callback method with response data" do
        callback = double("callback")
        callback.should_receive(:process_response).with('response data')
        stub_request(:get, "http://example.com/?date=now").to_return(status: 200, body: 'response data', headers: {})
        Rumba::Crawler.get_data('http://example.com', {date: 'now'}) { |response| callback.process_response(response)}
      end

      it "should raise exception on bad response" do
        stub_request(:get, "http://example.com/?date=now").to_return(status: 400)
        expect {Rumba::Crawler.get_data('http://example.com', {date: 'now'}) { |response| }}.to raise_error(Exceptions::BadResponse)
      end
    end
  end
end