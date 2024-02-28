# frozen_string_literal: true

class LocationSearch
  include ActiveRecord::Sanitization::ClassMethods

  InvalidOperator = Class.new(StandardError)

  FILTERS = %i[
    filter_id filter_name filter_category filter_zone
  ].freeze

  def initialize(**params)
    @params = params
  end

  def search(dataset: nil)
    @dataset = dataset || Location

    FILTERS.each { send(_1) }

    @dataset
  end

  private

  def filter_id
    where(id: @params[:id]) if @params[:id]
  end

  def filter_name
    where('name ILIKE ?', "%#{sanitize_sql_like(@params[:name])}%") if @params[:name]
  end

  def filter_category
    where(category: @params[:category]) unless @params[:category].nil?
  end

  def filter_zone
    where(zone_id: @params[:zone_id]) unless @params[:zone_id].nil?
  end

  def where(...)
    @dataset = @dataset.where(...)
  end
end
