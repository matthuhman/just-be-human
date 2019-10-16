class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notifications

  def index
  end

  def mark_as_read
    @notifications.update_all(read_at: Time.current)
  end

  private

  def set_notifications
    @notifications = Notification.where(recipient: current_user, created_at: (Time.current - 24.hours)..Time.current)
  end

end
