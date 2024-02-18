# frozen_string_literal: true

module VKPM2
  module Organizers
    class SetConfigValue
      include Interactor::Organizer

      organize Interactors::InitializeConfig,
               Interactors::SetConfig,
               Interactors::SaveConfig
    end
  end
end
