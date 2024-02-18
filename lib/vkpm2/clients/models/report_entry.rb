# frozen_string_literal: true

module VKPM2
  module Clients
    module Models
      class ReportEntry
        class << self
          def from_html(html)
            arr = Nokogiri::HTML(html)
              .xpath('//table[@id="history"]//tr')
              .to_a
              .map { |tr| [general_line(tr), activity(tr)].flatten }

            []
          end

          def general_line(tr)
            tr.xpath('.//td').to_a.map(&:text).map(&:strip)
          end

          def activity(tr)
            option = tr.xpath('.//td//option[@selected]')
            { id: option.attr('value').text, name: option.text }
          end
        end
      end
    end
  end
end
