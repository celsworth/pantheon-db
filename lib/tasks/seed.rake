# frozen_string_literal: true

namespace :seed do
  task resources: :environment do
    location = Location.first
    10_000.times do
      loc_x = Random.rand(3000)
      loc_y = Random.rand(3000)
      loc_z = Random.rand(500)

      name = 'Apple Tree'
      category = 'tree'

      Resource.create(location:, name:, size: 'normal', category:, tier: 1, loc_x:, loc_y:, loc_z:)
    end
  end
end
