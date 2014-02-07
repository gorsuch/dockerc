module Dockerc
  class Normalizer
    def handle_request_query(h)
      h.inject({}) do |memo,(k,v)|
        memo[handle_request_query_key(k)] = handle_request_query_value(v)
        memo    
      end
    end

    def handle_request_query_key(s)
      parts = s.to_s.split('_')
      parts.map!(&:capitalize)
      parts.first.downcase!
      parts.join
    end

    def handle_request_query_value(s)
      case s
      when TrueClass
        1
      when FalseClass
        0
      else
        s
      end
    end

    def handle_requeest_body(h)
    end

    def handle_request_key(s)
    end
  
    def handle_response_hash(h)
      h.inject({}) do |memo, (k,v)|
        memo[handle_response_hash_param(k)] = v
        memo
      end
    end

    def handle_response_hash_param(s)
      s.to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
    end

    def handle_response_data(data)
      case data
      when Hash
        handle_response_hash(data)
      when Array
        data.map { |h| handle_response_hash h }
      end
    end
  end
end
