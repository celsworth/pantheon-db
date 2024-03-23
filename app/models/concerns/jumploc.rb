# frozen_string_literal: true

module Jumploc
  def jumploc; end

  def jumploc=(jumploc)
    # parse x/z/y out of a /jumploc string

    return unless (matches = jumploc&.match(%r{\A/jumploc (\S+) (\S+) (\S+)}))

    self.loc_x = matches[1]
    self.loc_z = matches[2]
    self.loc_y = matches[3]
  end
end
