# frozen_string_literal: true

module VKPM
  module Clients
    module Models
      class Activity
        class << self
          def from_html(html)
            Nokogiri::HTML(html)
                    .xpath('//select[@id="id_activity"]//option')
                    .map { |option| Entities::Activity.new(id: option.attr('value').to_s, name: option.text) }
          end
        end
      end
    end
  end
end
