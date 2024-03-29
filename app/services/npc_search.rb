# frozen_string_literal: true

class NpcSearch
  include ActiveRecord::Sanitization::ClassMethods

  InvalidOperator = Class.new(StandardError)

  FILTERS = %i[
    filter_id filter_name filter_subtitle filter_vendor filter_location filter_zone
    filter_gives_quest_id filter_receives_quest_id filter_sells_item_id
  ].freeze

  def initialize(**params)
    @params = params
  end

  def search(dataset: nil)
    @dataset = dataset || Npc

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

  def filter_subtitle
    where('subtitle ILIKE ?', "%#{sanitize_sql_like(@params[:subtitle])}%") if @params[:subtitle]
  end

  def filter_vendor
    where(vendor: @params[:vendor]) unless @params[:vendor].nil?
  end

  def filter_location
    where(location_id: @params[:location_id]) unless @params[:location_id].nil?
  end

  def filter_zone
    return if @params[:zone_id].nil?

    ids = Npc.joins(:location).where('location.zone_id': @params[:zone_id])
    where(id: ids)
  end

  def filter_gives_quest_id
    return unless @params[:gives_quest_id]

    ids = Npc.joins(:quests_given).where('quests_given.id': @params[:gives_quest_id])
    where(id: ids)
  end

  def filter_receives_quest_id
    return unless @params[:receives_quest_id]

    ids = Npc.joins(:quests_received).where('quests_given.id': @params[:receives_quest_id])
    where(id: ids)
  end

  def filter_sells_item_id
    return unless @params[:sells_item_id]

    ids = Npc.joins(:sells_items).where('sells_items.id': @params[:sells_item_id])
    where(id: ids)
  end

  def where(...)
    @dataset = @dataset.where(...)
  end
end
