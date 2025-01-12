module Authentication
  module Providers
    # Authentication provider
    class Provider
      delegate :email, :nickname, to: :info, prefix: :user
      delegate :user_created_at_field, :user_username_field, to: :class

      def initialize(auth_payload)
        @auth_payload = cleanup_payload(auth_payload.dup)
        @info = auth_payload.info
        @raw_info = auth_payload.extra.raw_info
      end

      # Extract data for a brand new user
      def new_user_data
        raise SubclassResponsibility
      end

      # Extract data for an existing user
      def existing_user_data
        raise SubclassResponsibility
      end

      def name
        auth_payload.provider
      end

      def payload
        auth_payload
      end

      def self.provider_name
        name.demodulize.downcase.to_sym
      end

      def self.user_created_at_field
        raise SubclassResponsibility
      end

      def self.user_username_field
        raise SubclassResponsibility
      end

      def self.official_name
        raise SubclassResponsibility
      end

      def self.settings_url
        raise SubclassResponsibility
      end

      # rubocop:disable Style/OptionHash
      def self.authentication_path(params = {})
        ::Authentication::Paths.authentication_path(provider_name, params)
      end
      # rubocop:enable Style/OptionHash

      def self.sign_in_path(_params = {})
        raise SubclassResponsibility
      end

      protected

      # Remove sensible data from the payload
      def cleanup_payload(_auth_payload)
        raise SubclassResponsibility
      end

      attr_reader :auth_payload, :info, :raw_info
    end
  end
end
