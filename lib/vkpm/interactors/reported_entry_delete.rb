# frozen_string_literal: true

module VKPM
  module Interactors
    class ReportedEntryDelete
      include Interactor
      include Vars::Website
      def call
        website.delete_reported_entry(entry_id)
      end

      private

      def entry_id
        raise Error, '`entry_id` is not set' unless context.entry_id

        context.entry_id
      end
    end
  end
end
