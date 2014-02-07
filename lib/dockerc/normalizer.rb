module Dockerc
  class Normalizer
    def to_query_hash(h)
      h.inject({}) do |memo,(k,v)|
        memo[to_query_param(k)] = v
        memo    
      end
    end

    def to_query_param(s)
      parts = s.to_s.split('_')
      parts.map!(&:capitalize)
      parts.first.downcase!
      parts.join
    end

    def to_outbound_hash(h)
    end

    def to_inbound_hash(h)
    end
  end
end
