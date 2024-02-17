# frozen_string_literal: true

class NpcSearch
  include ActiveRecord::Sanitization::ClassMethods

  InvalidOperator = Class.new(StandardError)

  FILTERS = %i[
    filter_name filter_subtitle filter_vendor filter_zone
    filter_gives_quest filter_receives_quest filter_sells_item
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

  def filter_name
    where('name ILIKE ?', "%#{sanitize_sql_like(@params[:name])}%") if @params[:name]
  end

  def filter_subtitle
    where('subtitle ILIKE ?', "%#{sanitize_sql_like(@params[:subtitle])}%") if @params[:subtitle]
  end

  def filter_vendor
    where(vendor: @params[:vendor]) unless @params[:vendor].nil?
  end

  def filter_zone
    where(zone_id: @params[:zone_id]) unless @params[:zone_id].nil?
  end

  def filter_gives_quest
    return unless @params[:gives_quest]

    ids = Npc.joins(:quests_given).where('quests_given.id': @params[:gives_quest])
    where(id: ids)
  end

  def filter_receives_quest
    return unless @params[:receives_quest]

    ids = Npc.joins(:quests_received).where('quests_given.id': @params[:receives_quest])
    where(id: ids)
  end

  def filter_sells_item
    return unless @params[:sells_item]

    ids = Npc.joins(:sells_items).where('sells_items.id': @params[:sells_item])
    where(id: ids)
  end

  def where(...)
    @dataset = @dataset.where(...)
  end
end
