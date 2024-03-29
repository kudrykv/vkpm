# frozen_string_literal: true

module VKPM
  module Organizers
    class AuthLogin
      include Interactor::Organizer

      organize Interactors::ConfigInitialize,
               Interactors::WebsiteInitialize,
               Interactors::WebsiteLogin,
               Interactors::ConfigSetKeyValue
    end
  end
end
