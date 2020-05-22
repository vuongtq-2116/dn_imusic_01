namespace :lyric_request do
  desc "use whenever deleted lyrics not censored by the end of the month"
  task delete_lyric_in_eof_month: :environment do
    LyricRequest.is_unapprove.delete_all
  end
end
