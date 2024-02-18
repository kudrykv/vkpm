# frozen_string_literal: true

module VKPM2
  module Entities
    class HistoryEntry
      attr_accessor :id, :publish_date, :project, :activity, :task, :overtime, :source
    end
  end
end
