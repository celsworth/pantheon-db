# frozen_string_literal: true

class ItemSearch
  include ActiveRecord::Sanitization::ClassMethods

  InvalidOperator = Class.new(StandardError)

  FILTERS = %i[
    filter_id filter_name filter_weight filter_required_level filter_category
    filter_slot filter_stats filter_class filter_attrs
    filter_dropped_by_id filter_reward_from_quest_id filter_starts_quest_id
  ].freeze

  def initialize(**params)
    @params = params
  end

  def search(dataset: nil)
    @dataset = dataset || Item

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

  def filter_weight
    weight = case @params[:weight]
             when Array then @params[:weight]
             when Hash then [@params[:weight]]
             else return
             end

    weight.each do |h|
      raise InvalidOperator unless ['>=', '>', '<=', '<', '='].include?(h[:operator])

      where("weight #{h[:operator]} ?", h[:value])
    end
  end

  def filter_required_level
    required_level = case @params[:required_level]
                     when Array then @params[:required_level]
                     when Hash then [@params[:required_level]]
                     else return
                     end

    required_level.each do |h|
      raise InvalidOperator unless ['>=', '>', '<=', '<', '='].include?(h[:operator])

      where("required_level #{h[:operator]} ?", h[:value])
    end
  end

  def filter_category
    # override some meta-categories
    category = Item::META_CATEGORIES[@params[:category]] || @params[:category]

    where(category:) if category
  end

  def filter_slot
    where('slot = ?', @params[:slot]) if @params[:slot]
  end

  def filter_class
    where('classes @> ?', "[#{@params[:class].to_json}]") if @params[:class]
  end

  def filter_stats
    stats = case @params[:stats]
            when Array then @params[:stats]
            when Hash then [@params[:stats]]
            else return
            end

    stats.each do |h|
      raise InvalidOperator unless ['>=', '>', '<=', '<', '='].include?(h[:operator])

      where("(stats->>?)::decimal #{h[:operator]} ?", h[:stat], h[:value])
    end
  end

  def filter_attrs
    attrs = case @params[:attrs]
            when Array then @params[:attrs]
            when Hash then [@params[:attrs]]
            else return
            end

    attrs.each do |attr|
      where('attrs @> ?', "[#{attr.to_json}]")
    end
  end

  def filter_dropped_by_id
    return unless @params[:dropped_by_id]

    # @params[:dropped_by] should be a monster id
    ids = Item.joins(:dropped_by).where('dropped_by.id': @params[:dropped_by_id])
    where(id: ids)
  end

  def filter_reward_from_quest_id
    return unless @params[:reward_from_quest_id]

    # @params[:reward_from_quest] should be a quest id
    # ids = Item.joins(:reward_from_quest).where('reward_from_quest.id': @params[:reward_from_quest])
    ids = QuestReward.where(quest_id: @params[:reward_from_quest_id]).select(:item_id)
    where(id: ids)
  end

  def filter_starts_quest_id
    return unless @params[:starts_quest_id]

    ids = Item.joins(:starts_quest).where('starts_quest.id': @params[:starts_quest_id])
    where(id: ids)
  end

  def where(...)
    @dataset = @dataset.where(...)
  end
end
