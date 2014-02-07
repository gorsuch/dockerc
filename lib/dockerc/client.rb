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

      normalizer.handle_response_data(JSON.parse(json))
    end

    def create_container(params)
      req = {
        path:    '/containers/create',
        body:    normalizer.handle_request_data(params).to_json,
        expects: [ 201 ]
      }
      begin
        res = connection.post(req)
      rescue Excon::Errors::InternalServerError => e
        raise Dockerc::Errors::ContainerCreationError, e.response.body
      rescue Excon::Errors::NotFound
        raise Dockerc::Errors::ImageNotFound
      end

      normalizer.handle_response_data(JSON.parse(res.body))
    end

    def create_image(params)
      parts = []
      streamer = lambda do |chunk, remaining_bytes, total_bytes|
        data = JSON.parse(chunk)
        parts << normalizer.handle_response_data(data)
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

      normalizer.handle_response_data(JSON.parse(json))
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
