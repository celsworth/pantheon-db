# frozen_string_literal: true

module Api
  module V1
    class ApiController < ActionController::API
      wrap_parameters false

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      def not_found
        render json: { "error": 'not_found' }, status: :not_found
      end
    end
  end
end
