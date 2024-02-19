# frozen_string_literal: true

module VKPM2
  module Clients
    module Models
      class Holiday
        class << self
          def from_html(html)
            Nokogiri::HTML(html)
                    .xpath('//*[contains(@id, "holiday")]//span')
                    .text
                    .strip
                    .squeeze(' ')
                    .split(',')
                    .map { |line| line.gsub(/^.*\n (.*)$/, '\1').strip }
                    .map { |line| line.gsub(/^([^(]+)\(([^)]+)\)/, '\1, \2').split(',') }
                    .map { |row| Entities::Holiday.new(name: row[0], date: Date.parse(row[1])) }
          end
        end
      end
    end
  end
end
