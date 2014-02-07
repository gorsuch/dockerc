module Dockerc
  class Client
    attr_reader :docker_url

    def initialize(args={})
      @docker_url = args.fetch(:docker_url, ENV['DOCKER_URL'] || 'unix:///var/run/docker.sock')
    end

    def connection
      @connection ||= create_connection!
    end

    def create_connection!
      uri = URI.parse docker_url
      if uri.scheme == 'unix'
        Excon.new('unix:///', socket: uri.path, persistent: true)
      else
        Excon.new(docker_url, persistent: true)
      end
    end

    def containers
      json = connection.get({
        path: '/containers/json',
        query: { all: 1 },
        expects: [ 200 ]
      }).body

      JSON.parse(json).map do |h|
        normalizer.response_hash(h)
      end
    end

    def create_image(params)
      parts = []
      streamer = lambda do |chunk, remaining_bytes, total_bytes|
        data = JSON.parse(chunk)
        parts << normalizer.response_hash(data)
      end
      body = connection.post({
        path:    '/images/create',
        query:   normalizer.request_query(params),
        expects: [ 200 ],
        response_block: streamer
      }).body
      parts
    end

    def images
      json = connection.get({
        path:    '/images/json',
        query:   { all: 1 },
        expects: [ 200 ]
      }).body

      JSON.parse(json).map do |h|
        normalizer.response_hash(h)
      end
    end

    def normalizer
      @normalizer ||= Dockerc::Normalizer.new
    end

    def outbound_hash(h)
      h.inject({}) do |memo, (k,v)|
        memo[param_normalizer.for_outbound(k)] = v
        memo
      end
    end
  end
end
