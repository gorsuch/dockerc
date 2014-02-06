module Dockerc
  class ParamNormalizer
    def for_inbound(s)
      s.gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
    end

    def for_outbound(s)
      parts = s.to_s.split('_')
      parts.map(&:capitalize).join
    end
  end
end
