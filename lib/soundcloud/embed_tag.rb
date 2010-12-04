require 'uri'

module Soundcloud
  class EmbedTag
    
    @config = {:base_url => 'http://api.soundcloud.com'}  
      
    class << self
      attr_reader :config

      def api_url(track_url)
        uri = URI.parse track_url
        user, track = uri.path[1..-1].split('/')
        "#{config[:base_url]}/users/#{user}/tracks/#{track}.json?consumer_key=#{config[:consumer_key]}"
      end
      
      def get_track(api_url)
        raise ConsumerKeyError unless config[:consumer_key]
        HTTParty.get(api_url).parsed_response
      end
      
      def embed_code(track_url)
        track = get_track(api_url(track_url))
        id = track['id']
        
        %{<object height="81" width="100%"> <param name="movie" value="//player.soundcloud.com/player.swf?url=%2F%2Fapi.soundcloud.com%2Ftracks%2F#{id}&amp;show_comments=true&amp;auto_play=false"></param> <param name="allowscriptaccess" value="always"></param> <embed allowscriptaccess="always" height="81" src="//player.soundcloud.com/player.swf?url=%2F%2Fapi.soundcloud.com%2Ftracks%2F#{id}&amp;show_comments=true&amp;auto_play=false" type="application/x-shockwave-flash" width="100%"></embed> </object>}
      end
      
      def replace_tags(string)
        string.gsub /\[sc:(.*?)\]/ do |track_url|
          embed_code($1)
        end
      end
      
    end
    
  end
end