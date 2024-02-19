# frozen_string_literal: true

def models
  [Patch, Zone, Settlement, Dungeon, Location, Monster, Npc, Item,
   Quest, QuestObjective, QuestReward, Resource]
end

namespace :db do
  task dump: :environment do
    models.each do |model|
      data = model.all.to_json
      File.write("dumps/#{model}.json", data)
    end
  end

  task restore: :environment do
    models.each do |model|
      json = File.read("dumps/#{model}.json")
      data = JSON.parse(json)
      data.each do |row|
        model.create!(row)
      end
    rescue StandardError => e
      puts "#{model} ignoring #{e}"
      nil
    end
  end
end
