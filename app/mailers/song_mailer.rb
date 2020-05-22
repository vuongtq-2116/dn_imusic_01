class SongMailer < ApplicationMailer
  def notify_new_song song
    @song = song
    mail to: User.active.pluck(:email), subject: t("song_mailer.subject")
  end
end
