module Soundcloud
  class EmbedTag
    class ConsumerKeyError < StandardError
      def initialize(msg = 'Consumer key not set!')
        super(msg)
      end
    end
  end
end