require 'spec_helper'

describe Soundcloud::EmbedTag do
  KEY = 'Dc0xX2scpT6xXIFEc6GQ'
  
  before :all do
    Soundcloud::EmbedTag.config[:consumer_key] = KEY
  end
  
  it 'accepts configuration' do
    Soundcloud::EmbedTag.config[:foo] = :bar
    Soundcloud::EmbedTag.config[:foo].should == :bar
  end
  
  it 'parses track url' do
    Soundcloud::EmbedTag.api_url('http://soundcloud.com/jonnie-cache/cinnamon-hype').should == "http://api.soundcloud.com/users/jonnie-cache/tracks/cinnamon-hype.json?consumer_key=#{KEY}"
  end
  
  context 'getting a track' do
    before :all do
      @track = Soundcloud::EmbedTag.get_track(Soundcloud::EmbedTag.api_url('http://soundcloud.com/jonnie-cache/cinnamon-hype'))
    end
    
    it 'gets a track as a hash' do
      @track.should be_a(Hash)
    end

  end

  context 'with fake feeds' do
    before :all do
      Soundcloud::EmbedTag.stub(:get_track).with('http://soundcloud.com/jonnie-cache/cinnamon-hype').and_return fake_track('cinnamon-hype')
      Soundcloud::EmbedTag.stub(:get_track).with('http://soundcloud.com/jonnie-cache/moogalong').and_return fake_track('moogalong')
      @track = Soundcloud::EmbedTag.get_track('http://soundcloud.com/jonnie-cache/cinnamon-hype')
    end
    
    it 'parses out the structure' do
      @track['id'].should == 2252076
    end
    
    it 'builds the embed code' do
      Soundcloud::EmbedTag.embed_code('http://soundcloud.com/jonnie-cache/cinnamon-hype').should == '<object height="81" width="100%"> <param name="movie" value="http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F2252076&amp;show_comments=true&amp;auto_play=false"></param> <param name="allowscriptaccess" value="always"></param> <embed allowscriptaccess="always" height="81" src="http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F2252076&amp;show_comments=true&amp;auto_play=false" type="application/x-shockwave-flash" width="100%"></embed> </object>   <span><a href="http://soundcloud.com/jonnie-cache/cinnamon-hype">Cinnamon Hype (Tempa T vs. Dunkelbunt)</a> by <a href="http://soundcloud.com/jonnie-cache">JonnieCache</a></span>'
    end
    
    it 'replaces a tag with embed codes' do
      Soundcloud::EmbedTag.replace_tags('aaa [sc:http://soundcloud.com/jonnie-cache/cinnamon-hype] bbb').should == 'aaa <object height="81" width="100%"> <param name="movie" value="http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F2252076&amp;show_comments=true&amp;auto_play=false"></param> <param name="allowscriptaccess" value="always"></param> <embed allowscriptaccess="always" height="81" src="http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F2252076&amp;show_comments=true&amp;auto_play=false" type="application/x-shockwave-flash" width="100%"></embed> </object>   <span><a href="http://soundcloud.com/jonnie-cache/cinnamon-hype">Cinnamon Hype (Tempa T vs. Dunkelbunt)</a> by <a href="http://soundcloud.com/jonnie-cache">JonnieCache</a></span> bbb'
    end
    
    it 'replaces multiple tags with embed codes' do
      Soundcloud::EmbedTag.replace_tags('aaa [sc:http://soundcloud.com/jonnie-cache/cinnamon-hype] bbb [sc:http://soundcloud.com/jonnie-cache/moogalong] ccc').should == 'aaa <object height="81" width="100%"> <param name="movie" value="http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F2252076&amp;show_comments=true&amp;auto_play=false"></param> <param name="allowscriptaccess" value="always"></param> <embed allowscriptaccess="always" height="81" src="http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F2252076&amp;show_comments=true&amp;auto_play=false" type="application/x-shockwave-flash" width="100%"></embed> </object>   <span><a href="http://soundcloud.com/jonnie-cache/cinnamon-hype">Cinnamon Hype (Tempa T vs. Dunkelbunt)</a> by <a href="http://soundcloud.com/jonnie-cache">JonnieCache</a></span> bbb <object height="81" width="100%"> <param name="movie" value="http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F7061164&amp;show_comments=true&amp;auto_play=false"></param> <param name="allowscriptaccess" value="always"></param> <embed allowscriptaccess="always" height="81" src="http://player.soundcloud.com/player.swf?url=http%3A%2F%2Fapi.soundcloud.com%2Ftracks%2F7061164&amp;show_comments=true&amp;auto_play=false" type="application/x-shockwave-flash" width="100%"></embed> </object>   <span><a href="http://soundcloud.com/jonnie-cache/moogalong">Moogalong (Jean Jacques Perrey vs. Crazy Titch)</a> by <a href="http://soundcloud.com/jonnie-cache">JonnieCache</a></span> ccc'
    end
    
  end
  
  context 'with unset key' do
    before :all do
      Soundcloud::EmbedTag.config[:consumer_key] = nil
    end
    
    it 'returns an exception when getting a track' do
      lambda {Soundcloud::EmbedTag.get_track('http://soundcloud.com/foo/bar')}.should raise_error Soundcloud::EmbedTag::ConsumerKeyError
    end
    
    
  end
end