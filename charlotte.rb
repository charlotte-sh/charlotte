require './requirements'

stty_save = `stty -g`.chomp
trap('INT') { system('stty', stty_save); exit }

Application.new.run
