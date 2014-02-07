module Dockerc
  class Normalizer
    def request_query(h)
      h.inject({}) do |memo,(k,v)|
        memo[request_query_param(k)] = v
        memo    
      end
    end

    def request_query_param(s)
      parts = s.to_s.split('_')
      parts.map!(&:capitalize)
      parts.first.downcase!
      parts.join
    end

    def requeest_body(h)
    end

    def request_body_param(s)
    end
  
    def response_hash(h)
      h.inject({}) do |memo, (k,v)|
        memo[response_hash_param(k)] = v
        memo
      end
    end

    def response_hash_param(s)
      s.to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
    end
  end
end
