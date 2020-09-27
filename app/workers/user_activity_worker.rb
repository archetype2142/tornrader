class UserActivityWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true, failures: true

  def perform(user_id)
    user = User.find(user_id)
    if (user.trades.last.created_at < 7.days.ago)
      user.inactive!
    end
  end
end