require 'digest/md5'
require 'rubygems'
require 'facets/file/write'

module Kernel
 alias :original_eval :eval

=begin rdoc

 doctest: eval saves away files into some path, then eval's them from there
 >> eval "$a = 3"
 >> File.directory? '.remembered_evals'
 => true
 >> $a
 => 3

 doctest: TODO works with class methods, too too [and let them pass unharmed, since they're string eval's]
 > class A; end
 should work with a string
 > A.class_eval "def yo; 3; end"
 > A.instance_methods.contain? 'yo'
 > true
 and with a block, too
 > A.class_eval { def go; 3; end}
 > A.instance_methods.contain? 'go'

 this makes it work with backtraces...differently, too

 >> eval "begin; raise; rescue Exception => e; $a = e; end"
 >> $a.backtrace[0].include? '.remembered_evals/'
 >> true

=end

 def eval *args # string, binding, file, line [file and line are hereby ignored since ours supplant it]
  puts 'evaling away', args
  path = '.remembered_evals'
  Dir.mkdir path unless File.directory? path
  digest = Digest::MD5.hexdigest("Hello World\n")
  fullpath = path + '/' + Digest::MD5.hexdigest(args[0])
  saved = File.write(fullpath, args[0])
  original_eval args[0], args[1], fullpath, 1
 end

end

