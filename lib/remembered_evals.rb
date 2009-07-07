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

 TODO work with class_eval, too


 Using it causes the backtraces to behave slightly differently
 >> eval "begin; raise; rescue Exception => e; $a = e; end"
 >> $a.backtrace[0].include? '.remembered_evals/'
 >> true

=end

 def eval *args # string, binding, file, line [file and line are hereby ignored since ours supplant it]
  path = '.remembered_evals'
  Dir.mkdir path unless File.directory? path
  digest = Digest::MD5.hexdigest("Hello World\n")
  fullpath = path + '/' + Digest::MD5.hexdigest(args[0])
  saved = File.write(fullpath, args[0])
  original_eval args[0], args[1], fullpath, 1
 end

end

