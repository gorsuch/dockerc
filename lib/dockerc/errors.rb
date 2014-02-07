module Dockerc
  module Errors
    class ContainerCreationError < StandardError ; end
    class ImageNotFound < StandardError ; end
    class ImageCreationError < StandardError ; end
  end
end
