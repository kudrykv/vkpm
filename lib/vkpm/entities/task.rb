# frozen_string_literal: true

module VKPM
  module Entities
    class Task
      attr_accessor :name, :description, :status, :date, :starts_at, :ends_at, :span, :errors

      def initialize(name:, description:, status:, date:, starts_at:, ends_at:, span: nil)
        @name = name
        @description = description
        @status = status
        @date = date
        @starts_at = starts_at
        @ends_at = ends_at
        @span = span

        @errors = []
      end

      def valid?
        return false if errors.any?

        errors << 'name is not set' if name.nil?
        errors << 'description is not set' if description.nil?
        errors << 'status is not set' if status.nil?

        _div, mod = status.divmod(10)
        errors << 'status must be divisible by 10' unless mod.zero?
        errors << 'status must be within 0 and 100' unless status.between?(0, 100)

        errors << 'date is not set' if date.nil?

        errors << 'starts_at and ends_at or span must be set' if starts_at.nil? && ends_at.nil? && span.nil?

        if starts_at && ends_at && span && ((ends_at - starts_at).seconds != span)
          errors << 'starts_at, ends_at and span are not consistent'
        end

        errors << 'starts_at is after ends_at' if !starts_at.nil? && !ends_at.nil? && starts_at > ends_at

        unless span.nil?
          _div, mod = span.divmod(600)
          errors << 'span must be divisible by 10 minutes' unless mod.zero?
          errors << 'span must be within 0 and 24 hours' unless span.between?(0, 86_400)
        end

        errors.empty?
      end

      def similar?(other)
        instance_of?(other.class) &&
          name == other.name &&
          description.strip == other.description.strip &&
          status == other.status &&
          date == other.date &&
          starts_at.hour == other.starts_at.hour &&
          starts_at.min == other.starts_at.min &&
          ends_at.hour == other.ends_at.hour &&
          ends_at.min == other.ends_at.min
      end

      def align(day_entries)
        return put_first_entry if day_entries.empty?
        return check_time_duration(day_entries) if time_range_is_set?

        put_next_entry(day_entries)
      end

      def duration
        (ends_at - starts_at).seconds
      end

      private

      def put_first_entry
        return true if time_range_is_set?

        self.starts_at = date.beginning_of_day + 9.hours
        self.ends_at = starts_at + span

        raise Error, 'span spilled over to the next day' if ends_at > date.end_of_day
      end

      def check_time_duration(day_entries)
        raise Error, 'overlaps with existing entries' if overlaps?(day_entries)
      end

      def overlaps?(day_entries)
        day_entries.any? do |entry|
          ((entry.starts_at + 1.second)..(entry.ends_at - 1.second)).overlaps?(starts_at..ends_at)
        end
      end

      def time_range_is_set?
        starts_at && ends_at
      end

      def put_next_entry(day_entries)
        last = day_entries.last
        self.starts_at = last.task.ends_at
        self.ends_at = starts_at + span

        raise Error, 'span spilled over to the next day' if ends_at > starts_at.end_of_day
      end
    end
  end
end
