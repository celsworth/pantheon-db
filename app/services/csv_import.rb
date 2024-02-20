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
      when 'Harvesting'
        # X,Z,Y,Category,Name,Date
        create_resource(line)
      else
        raise line
      end
    end
  end

  private

  def thronefast
    @thronefast ||= Location.includes(:zone).find_by!(settlement_id: nil, dungeon_id: nil, zone: { name: 'Thronefast' })
  end

  def create_resource(attrs)
    new_attrs = { loc_x: attrs['X'], loc_y: attrs['Y'], loc_z: attrs['Z'],
                  location: thronefast, name: attrs['Name'] }
    r = Resource.new(new_attrs)
    r.autofill_from_name!

    return if r.save

    puts "#{r.name} - #{r.errors.full_messages}"
  end

  def create_npc(attrs)
    # X,Z,Y,Category,Name,NPC Role,Vendor,Trainer,Quest
    # NPC Role is like Shaman Scrolls
    # Trainer and Quest are bools, ignored for now
    new_attrs = {
      loc_x: attrs['X'], loc_y: attrs['Y'], loc_z: attrs['Z'],
      name: attrs['Name'], subtitle: attrs['NPC Role'], vendor: attrs['Vendor'] == 'Yes',
      location: thronefast
    }

    if (npc = Npc.find_by(name: attrs['Name']))
      npc.update(new_attrs)
    else
      Npc.create(new_attrs)
    end
  end
end
