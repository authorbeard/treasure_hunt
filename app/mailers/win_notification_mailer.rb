class WinNotificationMailer < ApplicationMailer 
  default from: "treasurehunt@example.com"

  def notify_winner
    @message = params[:message]
    mail(to: params[:player].email, subject: "You're a winner!")
  end
end