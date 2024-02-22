require 'clipboard'

prev_clipboard = ''
re = Regexp.new('^/jumploc \d+\.\d{2} \d+\.\d{2} \d+\.\d{2} \d+$')
loop do
  sleep 1

  clipboard = Clipboard.paste
  next if prev_clipboard == clipboard
  next unless clipboard.encode('US-ASCII').match(re)

  p clipboard
  # could do with working out how to avoid this encode, File.open(.., b:UTF-16LE) did not work
  utf8_clipboard = clipboard.encode('UTF-8')
  utf8_clipboard.tr!(' ', "\t") # replace spaces with tabs then Excel 365 detects cells properly
  utf8_clipboard << "\n"
  File.open('clipboard.txt', 'a') { |f| f.write(utf8_clipboard) }

  prev_clipboard = clipboard
end
