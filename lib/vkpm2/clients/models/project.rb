# frozen_string_literal: true

module VKPM2
  module Clients
    module Models
      class Project
        class << self
          def from_html(html)
            Nokogiri::HTML(html)
                    .xpath('//select[@id="id_project"]//option')
                    .map { |option| Entities::Project.new(id: option.attr('value').to_s, name: option.text) }
          end
        end
      end
    end
  end
end
