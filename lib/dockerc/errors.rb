module Dockerc
  module Errors
    class ContainerCreationError < StandardError ; end
    class ImageNotFound < StandardError ; end
    class ImagePullFailed < StandardError ; end
  end
end
