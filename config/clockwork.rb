# frozen_string_literal: true

require_relative "../config/boot"
require_relative "../config/environment"

require "clockwork"

module Clockwork
  infrequent_prices = Item.all.where(base_price: 0).pluck(:torn_id).map(&:to_i)

  api_key = User.find_by(username: "archetype2142").torn_api_key
  per_batch_time = 1.5
  batch_size = 5

  configure do |config|
    config[:tz] = "Etc/UTC"
    config[:logger] = Logger.new Rails.root.join("log", "clockwork.log")
  end

  every 15.minutes, "twenty-five-minutely" do
    LowestPointPriceFetchWorker.perform_async(api_key)
    
    User.active.auto_updated.pluck(:id).each_slice(batch_size).each_with_index do |user_batch, index|
      user_batch.each do |user_id|
        UpdateUserPricesWorker.perform_at(
          Time.now + (index * per_batch_time).minute,
          user_id
        )
      end
    end
    GC.start
  end

  every 15.minutes, "fifteen-minutely" do
    total_items = ((1..1065).to_a - infrequent_prices).each_slice(60).to_a

    (0..total_items.size).to_a.each_with_index do |item_set, index|
      LowestPriceFetchWorker.perform_at(
        Time.now + (index+1).minute,
        total_items[item_set], 
        api_key
      ) unless total_items[item_set].nil?
    end
    GC.start
  end

  every 6.hours, "six-hourly" do
    MarketValueFetchWorker.perform_async(api_key)
  end

  every 12.hours, "12-hourly" do
    update_prices = infrequent_prices.each_slice(60).to_a

    (0..update_prices.size).to_a.each_with_index do |item_set, index|
      LowestPriceFetchWorker.perform_at(
        Time.now + (index+1).minute, 
        total_items[item_set], 
        api_key
      )
    end
  end

  every 1.week, "weekly" do
    User.all.pluck(:id).each do |user_id|
      UserActivityWorker.perform_async(user_id)
    end
  end
end
