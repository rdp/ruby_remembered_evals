require 'digest/md5'
require 'rubygems'
require 'facets/file/write'
require 'facets/file/read' # File.sanitize


=begin rdoc
 doctest: eval saves away files into some path, then eval's them from there
 >> eval "$a = 3"
 >> File.directory? '._remembered_evals'
 => true
 >> $a
 => 3


 Using it causes the backtraces to behave slightly differently [I'd call it better]
 >> eval "begin; raise; rescue Exception => e; $exception = e; end"
 >> $exception.backtrace[0]
 => "._remembered_evals/beginraiserescueExceptiona48fc331d57ebd559347525d306d6a67:1:in `eval'"

=end
class RememberedEval
 def self.cache_code code_string
  path = '._remembered_evals'
  Dir.mkdir path unless File.directory? path
  # create something like /code0xdeadbeef for filename
  fullpath = path + '/' + File.sanitize(code_string[0..31]).gsub('_', '') + Digest::MD5.hexdigest(code_string)[0..63] # don't need too long here
  File.write(fullpath, code_string) unless File.exist? fullpath # write it out [prefer old data there, so people can edit them by hand if they are experimenting with eval'ed code]
  fullpath
 end

end

class Module
 alias :original_class_eval :module_eval

 def module_eval *args
  if block_given? # this one is already sourced
    original_class_eval { yield }
  else
    path = RememberedEval.cache_code args[0]
    original_class_eval args[0], path, 1 # no binding here
  end
 end
end

class Class
 alias :original_class_eval :class_eval

 def class_eval *args
  if block_given? # this one is already sourced
    original_class_eval { yield }
  else
    path = RememberedEval.cache_code args[0]
    original_class_eval args[0], path, 1 # no binding here
  end
 end
end


class Object
 alias :original_eval :eval
 def eval *args
   path = RememberedEval.cache_code args[0]
   original_eval args[0], args[1], path, 1 # args[1] is binding, args[0] is the code, ignore args[2], 3, which we replace :)
 end

end

=begin rdoc
 doctest: work with mod, too
 >> class A; end
 >> A.class_eval "def go3; 3; end"
 >> A.new.go3
 => 3

 doctest: it reverts back to normal [non-cached] behavior unless you pass it a binding [?]
 >> a = 3
 >> eval "a = 4"
 >> a
 => 4

 doctest: works with modules, too
 >> module M; end
 >> M.module_eval "def go; 3; end"
 >> M.instance_methods
 => ["go"]

=end

