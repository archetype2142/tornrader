# frozen_string_literal: true

class GeneratePriceTable
  class << self
    def execute(id)
      User.find(id).items << Item.basic
    end
  end
end
