# frozen_string_literal: true

module VKPM2
  module Clients
    module Models
      class Break
        class << self
          def from_html(html)
            Nokogiri::HTML(html)
                    .xpath('//table[@id="vacations"]//tr')
                    .map { |tr| tr.xpath('.//td').to_a.map(&:text).map(&:strip) }
                    .select { |row| row.size == 8 }
                    .map(&method(:hash_from_row))
                    .map { |hash| Entities::Break.new(**hash) }
          end

          private

          def hash_from_row(row)
            {
              id: row[0],
              start_date: Date.parse(row[2]),
              end_date: Date.parse(row[3]),
              used_days: row[4].to_i,
              approved: row[5].downcase == 'approved',
              paid: row[7].downcase == 'paid',
            }
          end
        end
      end
    end
  end
end
