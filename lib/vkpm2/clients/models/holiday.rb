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
                    .map(&method(:cleanup_dirt_on_start))
                    .map(&method(:split_holiday_name_and_date))
                    .map(&method(:initialize_holiday))
          end

          private

          def cleanup_dirt_on_start(line)
            line.gsub(/^.*\n (.*)$/, '\1').strip
          end

          def split_holiday_name_and_date(line)
            line.gsub(/^([^(]+)\(([^)]+)\)/, '\1, \2').split(',')
          end

          def initialize_holiday(row)
            Entities::Holiday.new(name: row[0], date: Date.parse(row[1]))
          end
        end
      end
    end
  end
end
