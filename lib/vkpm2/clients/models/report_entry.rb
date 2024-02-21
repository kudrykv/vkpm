# frozen_string_literal: true

module VKPM2
  module Clients
    module Models
      class ReportEntry
        class << self
          def from_html(html)
            Nokogiri::HTML(html)
                    .xpath('//table[@id="history"]//tr')
                    .to_a
                    .map { |tr| { raw: general_line(tr), activity: activity(tr) } }
                    .map { |hash| report_entry_bits(hash) }
                    .map { |hash| Entities::ReportEntry.new(**hash) }
                    .sort_by { |entry| entry.task.date }
          end

          def from_report_html_editable_ids(html)
            Nokogiri::HTML(html)
                    .xpath('//*[contains(@class, "report_table")]//tr[contains(@class, "report")]')
                    .map { |tr| tr.xpath('.//td').first.text }
          end

          def general_line(tr)
            tr.xpath('.//td').to_a.map(&:text).map(&:strip)
          end

          def activity(tr)
            option = tr.xpath('.//td//option[@selected]')
            Entities::Activity.new(id: option.attr('value').text, name: option.text)
          end

          def report_entry_bits(hash)
            {
              id: hash[:raw][0],
              activity: hash[:activity],
              publish_date: Time.parse(hash[:raw][1]),
              project: project(hash[:raw]),
              task: task(hash[:raw]),
              overtime: hash[:raw][11].size.positive?,
              source: hash[:raw][12]
            }
          end

          def project(raw)
            Entities::Project.new(id: nil, name: raw[3])
          end

          def task(raw)
            Entities::Task.new(
              name: raw[5],
              description: raw[6],
              status: raw[7].to_i,
              date: Date.parse(raw[2]),
              starts_at: Time.parse(raw[8]),
              ends_at: Time.parse(raw[9])
            )
          end
        end
      end
    end
  end
end
