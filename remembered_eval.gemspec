Gem::Specification.new do |s|
  s.name = %q{remembered_evals}
  s.version = "0.0.1"
 
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roger Pack"]
  s.date = %q{2009-05-22}
  s.description = s.summary = %q{library to save away eval'ed code to a file first, so that it can be seen later [ex: while debugging]}
  s.email = ["rogerdpack@gmail.comm"]
  s.files = ["lib/remembered_evals.rb"]
  s.homepage = %q{http://github.com/rogerdpack/ruby_remembered_eval/tree/master}
  s.require_paths = ["lib"]
 
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3
 
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<facets>, [">= 2.6.0"])
      s.add_development_dependency(%q<rubydoctest>, [">= 1.0.0"])
    else
      s.add_dependency(%q<facets>, [">= 2.6.0"])
    end
  else
    s.add_dependency(%q<facets>, [">= 2.6.0"])
  end
end
