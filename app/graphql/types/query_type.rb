# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: 'Fetches an object given its ID.' do
      argument :id, ID, required: true, description: 'ID of the object.'
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, { null: true }],
          null: true,
          description: 'Fetches a list of objects given a list of IDs.' do
      argument :ids, [ID], required: true, description: 'IDs of the objects.'
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :item, Types::ItemType do
      argument :id, ID
    end
    def item(id:)
      Item.find(id)
    end

    field :items, [Types::ItemType]
    def items
      Item.all
    end

    field :item_search, [Types::ItemType] do
      argument :params, Types::Inputs::ItemSearchInputType
    end
    def item_search(params:)
      ItemSearch.new(params:).search.all
    end

    field :monster, Types::MonsterType do
      argument :id, ID
    end
    def monster(id:)
      Monster.find(id)
    end

    field :monsters, [Types::MonsterType]
    def monsters
      Monster.all
    end

    field :zone, Types::ZoneType do
      argument :id, ID
    end
    def zone(id:)
      Zone.find(id)
    end

    field :zones, [Types::ZoneType]
    def zones
      Zone.all
    end
  end
end
