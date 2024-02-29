# frozen_string_literal: true

class QuestSearch
  include ActiveRecord::Sanitization::ClassMethods

  InvalidOperator = Class.new(StandardError)

  FILTERS = %i[
    filter_id filter_name filter_text filter_giver_id filter_receiver_id filter_prereq_quest_id
  ].freeze

  def initialize(**params)
    @params = params
  end

  def search(dataset: nil)
    @dataset = dataset || Quest

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

  def filter_text
    where('text ILIKE ?', "%#{sanitize_sql_like(@params[:text])}%") if @params[:text]
  end

  def filter_giver_id
    where(giver_id: @params[:giver_id]) if @params[:giver_id]
  end

  def filter_receiver_id
    where(receiver_id: @params[:receiver_id]) if @params[:receiver_id]
  end

  def filter_prereq_quest_id
    where(prereq_quest_id: @params[:prereq_quest_id]) if @params[:prereq_quest_id]
  end

  def where(...)
    @dataset = @dataset.where(...)
  end
end
