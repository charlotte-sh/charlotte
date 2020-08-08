require 'socket'
require 'etc'
require 'readline'
require './client'

puts
puts '   ________               __      __  __     v0.0 '
puts '  / ____/ /_  ____ ______/ /___  / /_/ /____      '
puts ' / /   / __ \/ __ `/ ___/ / __ \/ __/ __/ _ \     '
puts '/ /___/ / / / /_/ / /  / / /_/ / /_/ /_/  __/     '
puts '\____/_/ /_/\__,_/_/  /_/\____/\__/\__/\___/      '
puts

hostname = 'localhost'
client = Client.new(hostname)

stty_save = `stty -g`.chomp
trap('INT') { system('stty', stty_save); exit }

while input = Readline.readline('')
  client.send(input)
end
