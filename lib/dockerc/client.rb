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
        normalize_hash(h)
      end
    end

    def create_image(params)
      body = connection.post({
        path:    '/images/create',
        query:   normalizer.to_query_hash(params),
        expects: [ 200 ]
      }).body
      !!(body =~ /Download complete/)
    end

    def images
      json = connection.get({
        path:    '/images/json',
        query:   { all: 1 },
        expects: [ 200 ]
      }).body

      JSON.parse(json).map do |h|
        normalize_hash(h)
      end
    end

    def normalizer
      @normalizer ||= Dockerc::Normalizer.new
    end

    def normalize_hash(h)
      h.inject({}) do |memo, (k,v)|
        memo[param_normalizer.for_inbound(k)] = v
        memo
      end
    end

    def outbound_hash(h)
      h.inject({}) do |memo, (k,v)|
        memo[param_normalizer.for_outbound(k)] = v
        memo
      end
    end

    def normalize_query_param(s)
      parts = s.to_s.split('_')
      parts.map(&:upcase)
      parts.first.downcase!
      parts.join('')
    end

    def normalize_query_hash(h)
      h.inject({}) do |memo, (k,v)|
        memo[normalize_query_param(k)] = v
        memo
      end
    end

    def param_normalizer
      @param_normalizer ||= Dockerc::ParamNormalizer.new
    end
  end
end
