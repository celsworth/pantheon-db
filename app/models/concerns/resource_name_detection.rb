# frozen_string_literal: true

# Given a resource name, return a hash of data to fill a Resource row
#
class ResourceNameDetection
  # this does not contain Large/Huge/Patch etc, they are handled separately
  #
  # a lot of this is direct mapping now so could be removed and just use downcase
  # and leave in a few overrides (the bottom ones)
  NAME_TABLE = {
    'Jute' => { resource: 'jute' },
    'Cotton' => { resource: 'cotton' },

    'Blackberry' => { resource: 'blackberry' },
    'Gloomberry' => { resource: 'gloomberry' },

    'Apple' => { resource: 'apple' },
    'Pine' => { resource: 'pine' },
    'Maple' => { resource: 'maple' },
    'Ash' => { resource: 'ash' },
    'Oak' => { resource: 'oak' },
    'Walnut' => { resource: 'walnut' },

    'Asherite' => { resource: 'asherite' },
    'Caspilrite' => { resource: 'caspilrite' },
    'Padrium' => { resource: 'padrium' },
    'Tascium' => { resource: 'tascium' },
    'Slytheril' => { resource: 'slytheril' },

    'Flax' => { resource: 'flax' },

    'Flame' => { resource: 'lily' },
    'Moon' => { resource: 'lily' },
    'Wild Herbs' => { resource: 'herb' },
    'Wild Vegetables' => { resource: 'vegetable' },
    'Natural Garden' => { resource: 'vegetable' },

    'Water Reeds' => { resource: 'water_reed' }
  }.freeze

  def call(original_name)
    @name = original_name.dup
    fix_typos!
    remove_extraneous_info!
    data.merge!(detect_size!)
    data.merge!(detect_subresource!)

    unless (resource = NAME_TABLE[@name])
      raise "unrecognised #{@name}"
    end

    data.merge!(resource)

    data
  end

  private

  # remove surplus information from the name that doesn't help and in some cases just
  # makes it harder, ie Ore Deposit vs Crystals or Lily vs Lilies
  def remove_extraneous_info!
    @name.gsub!(/ Plant$/, '')
    @name.gsub!(/ Tree$/, '')
    @name.gsub!(/ Ore Deposit$/, '')
    @name.gsub!(/ Crystals$/, '')
    @name.gsub!(/ Bush$/, '')
    @name.gsub!(/ Stalk$/, '')
    @name.gsub!(/ Lily$/, '')
    @name.gsub!(/ Lilies$/, '')
  end

  # Work out what size the node should be from the original passed-in name,
  # then *if* that's a prefix, remove that part of the name. So for example,
  #   Huge Apple Tree -> huge and strip the name to Apple Tree
  #
  # however, Natural Garden is special, we return huge but don't strip anything
  #
  def detect_size!
    return { size: 'huge' } if @name.gsub!(/^Huge /, '')
    return { size: 'large' } if @name.gsub!(/^Large /, '')
    return { size: 'large' } if @name.gsub!(/^Patch of /, '')
    return { size: 'huge' } if @name['Natural Garden']

    { size: 'normal' }
  end

  # Work out what subresource is, if present, and remove it from the name, like detect_size!
  def detect_subresource!
    return { subresource: 'hardened' } if @name.gsub!(/^Hardened /, '')
    return { subresource: 'glittering' } if @name.gsub!(/^Glittering /, '')

    {}
  end

  # Normalise data in csv input to something we can parse
  def fix_typos!
    @name.gsub!(/(.*) - Large/, 'Large \1')
    @name.gsub!(/Caspilrite$/, 'Caspilrite Ore Deposit')
    @name.gsub!(/Padrium$/, 'Padrium Ore Deposit')
    @name.gsub!(/Tasc$/, 'Tascium')
    @name.gsub!(/Tasc /, 'Tascium ')
    @name.gsub!(/Ore$/, 'Ore Deposit')
    @name.gsub!(/Casperite/, 'Caspilrite')
    @name.gsub!(/Slytherin/, 'Slytheril')
    @name.gsub!(/Slytheril$/, 'Slytheril Crystals')
    @name.gsub!(/Deposite/, 'Deposit')
    @name.gsub!(/Depsoite/, 'Deposit')
    @name.gsub!(/Depositre/, 'Deposit')
    @name.gsub!(/Harned/, 'Hardened')
    @name.gsub!(/Harened/, 'Hardened')
    @name.gsub!(/Tascium$/, 'Tascium Ore Deposit')
    @name.gsub!(/Caspilrite$/, 'Caspilrite Ore Deposit')
    @name.gsub!(/Hardened Caspilrite Deposit/, 'Hardened Caspilrite Ore Deposit')

    @name.gsub!(/Blackberry$/, 'Blackberry Bush')
    @name.gsub!(/Blueberry/, 'Blackberry')

    @name.gsub!(/Hemp/, 'Jute')

    @name.gsub!(/Vild/, 'Wild')
    @name.gsub!(/wild/, 'Wild')

    @name.gsub!(/Kingsblom/, 'Flame Lily')
    @name.gsub!(/Kingsbloom/, 'Flame Lily')
    @name.gsub!(/Llly/, 'Lily')

    @name.gsub!(/^Vegetable$/, 'Wild Vegetables')

    @name.gsub!(/^Water Reed$/, 'Water Reeds')
  end

  def data
    @data ||= {}
  end
end
