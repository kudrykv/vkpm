# frozen_string_literal: true

module VKPM2
  module Tools
    class Chronic
      def self.human_readable_duration(minutes)
        [[60, :m], [Float::INFINITY, :h]].map do |count, name|
          minutes, number = minutes.divmod(count)
          "#{number.to_i}#{name}" unless number.to_i.zero?
        end.compact.reverse.join
      end
    end
  end
end
