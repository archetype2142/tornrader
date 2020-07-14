# frozen_string_literal: true

require_relative "../config/boot"
require_relative "../config/environment"

require "clockwork"

module Clockwork
  configure do |config|
    config[:tz] = "Etc/UTC"
    config[:logger] = Logger.new Rails.root.join("log", "clockwork.log")
  end

  every 1.hour, "fifty-minutely" do
    total_items = (1..1065).to_a.each_slice(60).to_a

    (0..17).to_a.each_with_index do |item_set, index|
      LowestPriceFetchWorker.perform_at(
        Time.now + (index+1).minute, 
        total_items[item_set], 
        User.find_by(username: "archetype2142").torn_api_key
      )
    end
  end

  every 1.hour, "hourly" do

  end
end