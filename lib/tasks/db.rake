# frozen_string_literal: true

def models
  [Patch, Zone, Location, Monster, Npc, Item,
   Quest, QuestObjective, QuestReward, Resource]
end

namespace :db do
  task dump: :environment do
    models.each do |model|
      data = model.order(:id).all.to_json
      File.write("dumps/#{model}.json", data)
    end
  end

  task restore: :environment do
    models.each do |model|
      json = File.read("dumps/#{model}.json")
      data = JSON.parse(json)
      data.each do |row|
        row.delete('id')
        model.create!(row)
      rescue StandardError => e
        puts "#{model} ignoring #{e} for #{row}"
        nil
      end
    end
  end
end
