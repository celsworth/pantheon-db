require 'nokogiri'

# cat ~/Downloads/test2.svg | rails svg2elm | elm-format --stdin >Test.elm

# these attributes are removed, the svg has no fonts in it anyway
REMOVE_KEYS = %w[
  font-size font-style font-family font-weight
]

# these are removed if the value matches
REMOVE_KEYS_IF_VALUE = {
  'vector-effect' => 'none' # default!
}

def parse_element(e)
  keys = e.keys - REMOVE_KEYS
  attrs = keys.map { |k| [k, e[k]] }.to_h
  attrs = attrs.map do |k, v|
    next if REMOVE_KEYS_IF_VALUE[k] == v

    <<~OUT
      attribute "#{k}" "#{v}"
    OUT
  end.compact

  return if e.name == 'g' && e.children.empty?

  children = e.children.map { parse_element(_1) }

  return unless attrs.any? || children.any?

  <<~OUT
    Svg.node "#{e.name}" [ #{attrs.compact.join(',')} ] [ #{children.compact.join(',')} ]
  OUT
end

task :svg2elm do
  xml = Nokogiri::XML($stdin)

  out = xml.children.map do |e|
    parse_element(e)
  end
  puts <<~OUT
    module Maps.Test exposing (test)
    import Svg
    import VirtualDom exposing (attribute)

    test: Svg.Svg msg
    test = #{out.compact.join(',')}
  OUT
end
