require 'readline'

puts
puts '   ________               __      __  __.    v0.0 '
puts '  / ____/ /_  ____ ______/ /___  / /_/ /____      '
puts ' / /   / __ \/ __ `/ ___/ / __ \/ __/ __/ _ \     '
puts '/ /___/ / / / /_/ / /  / / /_/ / /_/ /_/  __/     '
puts '\____/_/ /_/\__,_/_/  /_/\____/\__/\__/\___/      '
puts

prompt = '> '

while input = Readline.readline(prompt, true)
  puts input
end
