# frozen_string_literal: true

require 'csv'

class CsvImport
  attr_reader :csv

  def initialize(csv)
    @csv = CSV.parse(csv, headers: true, converters: %i[numeric date])
  end

  def call
    csv.each do |line|
      case line['Category']
      when 'NPC'
        # X,Z,Y,Category,Name,NPC Role,Vendor,Trainer,Quest
        create_npc(line)
      else
        p line
      end
    end
  end

  private

  def create_npc(attrs)
    zone = Zone.find_by!(name: 'Thronefast')

    # X,Z,Y,Category,Name,NPC Role,Vendor,Trainer,Quest
    # NPC Role is like Shaman Scrolls
    # Trainer and Quest are bools, ignored for now
    new_attrs = {
      loc_x: attrs['X'],
      loc_y: attrs['Y'],
      loc_z: attrs['Z'],
      name: attrs['Name'],
      subtitle: attrs['NPC Role'],
      zone:
    }

    if (npc = Npc.find_by(name: attrs['Name']))
      npc.update(new_attrs)
    else
      Npc.create(new_attrs)
    end
  end
end
