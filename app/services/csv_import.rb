# frozen_string_literal: true

require 'csv'

class CsvImport
  attr_reader :csv

  def initialize(csv)
    @csv = CSV.parse(csv, headers: true, converters: %i[numeric date])
  end

  def call
    min_x = 99_999
    max_x = 0
    min_y = 99_999
    max_y = 0
    csv.each do |line|
      case line['Category']
      when 'NPC'
        # X,Z,Y,Category,Name,NPC Role,Vendor,Trainer,Quest
        create_npc(line)
      when 'Harvesting'
        # X,Z,Y,Category,Name,Date
        create_resource(line)

      #         p line['X']
      #         min_x = line['X'] if min_x > line['X']
      #         max_x = line['X'] if max_x < line['X']
      #         min_y = line['Y'] if min_y > line['Y']
      #         max_y = line['Y'] if max_y < line['Y']
      else
        raise line
      end
    end

    # p "x = #{min_x} to #{max_x}"
    # p "y = #{min_y} to #{max_y}"
  end

  private

  def thronefast
    @thronefast ||= Location.includes(:zone).find_by!(settlement_id: nil, dungeon_id: nil, zone: { name: 'Thronefast' })
  end

  RESOURCES = {
    'Jute Plant' => { resource: 'jute' },
    'Cotton Plant' => { resource: 'cotton' },

    'Blackberry Bush' => { resource: 'blackberry' },
    'Gloomberry Bush' => { resource: 'gloomberry' },

    'Apple Tree' => { resource: 'apple' },
    'Pine Tree' => { resource: 'pine' },
    'Maple Tree' => { resource: 'maple' },
    'Ash Tree' => { resource: 'ash' },
    'Oak Tree' => { resource: 'oak' },
    'Walnut Tree' => { resource: 'walnut' },

    'Asherite Ore Deposit' => { resource: 'asherite' },
    'Caspilrite Ore Deposit' => { resource: 'caspilrite' },
    'Hardened Caspilrite Ore Deposit' => { resource: 'caspilrite' }, # HARDENED TODO
    'Glittering Slytheril Crystals' => { resource: 'slytheril' }, # GLITTERING TODO
    'Padrium Ore Deposit' => { resource: 'padrium' },
    'Tascium Ore Deposit' => { resource: 'tascium' },
    'Tascium Crystals' => { resource: 'tascium' },
    'Slytheril Crystals' => { resource: 'slytheril' },

    'Wild Herbs' => { resource: 'herb' },

    'Flax Stalk' => { resource: 'flax' },

    'Flame Lily' => { resource: 'lily' },
    'Moon Lily' => { resource: 'lily' },
    'Moon Lilies' => { resource: 'lily' },

    'Wild Vegetables' => { resource: 'vegetable' },
    'Natural Garden' => { resource: 'vegetable' },

    'Water Reeds' => { resource: 'water_reeds' }
  }.freeze

  def create_resource(attrs)
    name = attrs['Name'].dup
    cleanup_resource_name!(name)
    insert_name = name.dup
    size = name_to_size!(name)
    name_to_resource = RESOURCES[name]

    unless name_to_resource
      puts "Unhandled #{name} - original: #{attrs['Name']} (size #{size})"
      return
    end

    new_attrs = {
      name: insert_name,
      loc_x: attrs['X'],
      loc_y: attrs['Y'],
      loc_z: attrs['Z'],
      location: thronefast
    }.merge(name_to_resource).merge(size)

    r = Resource.new(new_attrs)
    return if r.save

    p "#{r.name} - #{r.errors.full_messages}"
  end

  def cleanup_resource_name!(name)
    name.gsub!(/(.*) - Large/, 'Large \1')
    name.gsub!(/Caspilrite$/, 'Caspilrite Ore Deposit')
    name.gsub!(/Padrium$/, 'Padrium Ore Deposit')
    name.gsub!(/Tasc$/, 'Tascium')
    name.gsub!(/Tasc /, 'Tascium ')
    name.gsub!(/Ore$/, 'Ore Deposit')
    name.gsub!(/Casperite/, 'Caspilrite')
    name.gsub!(/Slytherin/, 'Slytheril')
    name.gsub!(/Slytheril$/, 'Slytheril Crystals')
    name.gsub!(/Deposite/, 'Deposit')
    name.gsub!(/Depsoite/, 'Deposit')
    name.gsub!(/Depositre/, 'Deposit')
    name.gsub!(/Harned/, 'Hardened')
    name.gsub!(/Harened/, 'Hardened')
    name.gsub!(/Tascium$/, 'Tascium Ore Deposit')
    name.gsub!(/Caspilrite$/, 'Caspilrite Ore Deposit')
    name.gsub!(/Hardened Caspilrite Deposit/, 'Hardened Caspilrite Ore Deposit')

    name.gsub!(/Blackberry$/, 'Blackberry Bush')
    name.gsub!(/Blueberry/, 'Blackberry')

    name.gsub!(/Hemp/, 'Jute')

    name.gsub!(/Vild/, 'Wild')
    name.gsub!(/wild/, 'Wild')

    name.gsub!(/Kingsblom/, 'Flame Lily')
    name.gsub!(/Kingsbloom/, 'Flame Lily')
    name.gsub!(/Llly/, 'Lily')

    name.gsub!(/^Vegetable$/, 'Wild Vegetables')

    name.gsub!(/^Water Reed$/, 'Water Reeds')
  end

  def name_to_size!(name)
    return { size: 'huge' } if name.gsub!(/^Huge /, '')
    return { size: 'large' } if name.gsub!(/^Large /, '')
    return { size: 'large' } if name.gsub!(/^Patch of /, '')
    return { size: 'huge' } if name['Natural Garden']

    { size: 'normal' }
  end

  def create_npc(attrs)
    location = Location.includes(:zone).find_by!(settlement_id: nil, dungeon_id: nil, zone: { name: 'Thronefast' })

    # X,Z,Y,Category,Name,NPC Role,Vendor,Trainer,Quest
    # NPC Role is like Shaman Scrolls
    # Trainer and Quest are bools, ignored for now
    new_attrs = {
      loc_x: attrs['X'],
      loc_y: attrs['Y'],
      loc_z: attrs['Z'],
      name: attrs['Name'],
      subtitle: attrs['NPC Role'],
      vendor: attrs['Vendor'] == 'Yes',
      location:
    }

    if (npc = Npc.find_by(name: attrs['Name']))
      npc.update(new_attrs)
    else
      Npc.create(new_attrs)
    end
  end
end
