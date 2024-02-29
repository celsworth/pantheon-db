# frozen_string_literal: true

class MonsterSearch
  include ActiveRecord::Sanitization::ClassMethods

  InvalidOperator = Class.new(StandardError)

  FILTERS = %i[
    filter_id filter_name
    filter_location filter_zone
    filter_elite filter_named filter_drops_id filter_level
  ].freeze

  def initialize(**params)
    @params = params
  end

  def search(dataset: nil)
    @dataset = dataset || Monster

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

  def filter_elite
    where(elite: @params[:elite]) unless @params[:elite].nil?
  end

  def filter_named
    where(elite: @params[:named]) unless @params[:named].nil?
  end

  def filter_location
    where(location_id: @params[:location_id]) unless @params[:location_id].nil?
  end

  def filter_zone
    return if @params[:zone_id].nil?

    ids = Monster.joins(:location).where('location.zone_id': @params[:zone_id])
    where(id: ids)
  end

  def filter_drops_id
    return unless @params[:drops_id]

    ids = Monster.joins(:drops).where('drops.id': @params[:drops_id])
    where(id: ids)
  end

  def filter_level
    level = case @params[:level]
            when Array then @params[:level]
            when Hash then [@params[:level]]
            else return
            end

    level.each do |h|
      raise InvalidOperator unless ['>=', '>', '<=', '<', '='].include?(h[:operator])

      where("level #{h[:operator]} ?", h[:value])
    end
  end

  def where(...)
    @dataset = @dataset.where(...)
  end
end
