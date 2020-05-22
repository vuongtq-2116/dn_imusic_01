module LyricRequestsHelper
  def load_lyric song
    LyricRequest.is_show(song.id).first
  end
end
