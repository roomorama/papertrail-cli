require 'faraday'
require 'time'

module Papertrail
  class SearchClient
    attr_accessor :username, :password, :conn

    def initialize(username, password)
      @username = username
      @password = password

      ssl_options = { :verify => OpenSSL::SSL::VERIFY_NONE }

      # Make Ubuntu OpenSSL work
      #
      # From: https://bugs.launchpad.net/ubuntu/+source/openssl/+bug/396818
      # "[OpenSSL] does not presume to select a set of CAs by default."
      #if File.file?('/etc/ssl/certs/ca-certificates.crt')
      #  ssl_options[:ca_file] = '/etc/ssl/certs/ca-certificates.crt'
      #end

      @conn = Faraday::Connection.new(:url => 'https://papertrailapp.com', :ssl => ssl_options) do |builder|
        builder.adapter  :net_http
      end
      @conn.basic_auth(@username, @password)

      @max_id_seen = {}
    end

    # search for all events or a specific query, defaulting to all events since
    # last result set (call with since=0 for all).
    def search(q = nil, since = nil)
      response = @conn.get('/api/v1/events/search.json') do |r|
        r.params = params_for_query(q, since)
      end
      
      if response.body
        response_json = ActiveSupport::JSON.decode(response.body)
        @max_id_seen[q] = response_json['max_id']
        response_json['events']
      end
    end

    def params_for_query(q = nil, since = nil)
      params = {}
      params[:q] = q if q
      params[:min_id] = @max_id_seen[q] if @max_id_seen[q]
      params[:min_id] = since if since
      params
    end

    def self.format_events(events, &block)
      events.each do |event|
        yield "#{Time.parse(event['received_at']).strftime('%b %e %X')} #{event['hostname']} #{event['program']} #{event['message']}"
      end
    end
  end
end
