# frozen_string_literal: true

class MonsterSearch
  include ActiveRecord::Sanitization::ClassMethods

  InvalidOperator = Class.new(StandardError)

  FILTERS = %i[
    filter_name filter_zone filter_elite filter_named filter_drops filter_level
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

  def filter_name
    where('name ILIKE ?', "%#{sanitize_sql_like(@params[:name])}%") if @params[:name]
  end

  def filter_elite
    where(elite: @params[:elite]) unless @params[:elite].nil?
  end

  def filter_named
    where(elite: @params[:named]) unless @params[:named].nil?
  end

  def filter_zone
    where(zone_id: @params[:zone_id]) unless @params[:zone_id].nil?
  end

  def filter_drops
    return unless @params[:drops]

    ids = Monster.joins(:drops).where('drops.id': @params[:drops])
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
