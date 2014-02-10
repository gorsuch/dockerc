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

      normalizer.handle_response_data(MultiJson.load(json))
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

      normalizer.handle_response_data(MultiJson.load(res.body))
    end

    def images
      json = connection.get({
        path:    '/images/json',
        query:   { all: 1 },
        expects: [ 200 ]
      }).body

      normalizer.handle_response_data(MultiJson.load(json))
    end

    def pull_image(name)
      parts = []
      streamer = lambda do |chunk, remaining_bytes, total_bytes|
        data = MultiJson.load(chunk)
        parts << normalizer.handle_response_data(data)
      end
      body = connection.post({
        path:    '/images/create',
        query:   normalizer.handle_request_query(from_image: name),
        expects: [ 200 ],
        response_block: streamer
      }).body
      unless parts.last.has_key?(:id)
        raise Dockerc::Errors::ImagePullFailed, parts
      end
      parts
    end

    private

    def normalizer
      @normalizer ||= Dockerc::Normalizer.new
    end
  end
end
