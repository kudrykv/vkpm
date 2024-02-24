# frozen_string_literal: true

module VKPM
  module Clients
    module Models
      class Compensation
        class << self
          def from_html(html, date)
            doc = Nokogiri::HTML.parse(html)
            some_rate = largest_rate_number(doc)
            total = total(doc)

            compensation = if some_rate / total < 0.1
                             Entities::CompensationRate.new(some_rate)
                           else
                             Entities::CompensationFixed.new(some_rate)
                           end

            Entities::Compensation.new(compensation:, date:)
          end

          private

          def largest_rate_number(doc)
            doc
              .xpath('//tr[contains(., "rate")]//td')
              .map(&:text)
              .select { |text| text.match(/\d+/) }
              .map { |text| text.gsub(/^\D+(\d+\.\d+)\D*$/, '\1') }
              .map(&:to_f)
              .max
          end

          def total(doc)
            doc
              .xpath('//tr[td[contains(., "Total / Paid")]]//td')
              .last
              .text
              .split('/')
              .first
              .to_f
          end
        end
      end
    end
  end
end
