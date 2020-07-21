class UniqueWorker
  include Sidekiq::Worker
  sidekiq_options lock: :until_executed, on_conflict: :reject, unique_args: -> (*args) { args }
end