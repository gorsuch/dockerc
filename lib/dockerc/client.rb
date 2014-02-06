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
        h.inject({}) do |memo, (k,v)|
          memo[param_normalizer.for_inbound(k)] = v
          memo
        end
      end
    end

    def create_container(args)
    end

    def param_normalizer
      @param_normalizer ||= Dockerc::ParamNormalizer.new
    end
  end
end
