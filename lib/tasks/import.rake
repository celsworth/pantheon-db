# frozen_string_literal: true

namespace :import do
  task npcs: :environment do
    CsvImport.new(File.read('List_of_NPCs.csv')).call
  end
end
