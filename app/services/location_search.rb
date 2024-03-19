# frozen_string_literal: true

class LocationSearch
  include ActiveRecord::Sanitization::ClassMethods

  InvalidOperator = Class.new(StandardError)

  FILTERS = %i[
    filter_id filter_name filter_category filter_zone filter_has_loc_coords
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

  def filter_has_loc_coords
    return unless defined?(@params[:has_loc_coords])

    tbl = Location.arel_table
    tbl_x = tbl[:loc_x]
    tbl_y = tbl[:loc_y]
    conditions = if @params[:has_loc_coords]
                   tbl_x.not_eq(nil).and(tbl_y.not_eq(nil))
                 else
                   tbl_x.eq(nil).and(tbl_y.eq(nil))
                 end

    where(tbl.grouping(conditions))
  end

  def where(...)
    @dataset = @dataset.where(...)
  end
end
