# frozen_string_literal: true

class GraphqlController < ApplicationController
  DEFAULT_PARAMS = {}.freeze

  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  skip_forgery_protection

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = { current_user:, guild_member: guild_member? }
    result = PantheonDbSchema.execute(query, variables:, context:, operation_name:)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String then variables_param.present? ? (JSON.parse(variables_param) || {}) : DEFAULT_PARAMS
    when Hash then variables_param
    when ActionController::Parameters then variables_param.to_unsafe_hash
    when nil then DEFAULT_PARAMS
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(err)
    logger.error err.message
    logger.error err.backtrace.join("\n")

    render json: { errors: [{ message: err.message, backtrace: err.backtrace }], data: {} }, status: 500
  end
end
