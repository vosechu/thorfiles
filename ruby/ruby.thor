require "thor"

class Ruby < Thor::Group # Thor::Group executes all methods at the same time
  include Thor::Actions

  # This will make template write into the directory where the thor command was issued
  def self.source_root
    File.dirname(__FILE__)
  end

  desc "generate a simple sinatra config"
  argument :name
  class_option :test_framework

  def create_template_files
    copy_file 'templates/.gitignore', "#{name}/.gitignore"
    template 'templates/Gemfile.tt', "#{name}/Gemfile"
    template 'templates/app.tt', "#{name}/lib/#{name}.rb"

    # MiniTest::Unit
    if options[:test_framework] == "minitest"
      template 'templates/test.tt', "#{name}/test/test_#{name}.rb"

    # MiniTest::Spec
    elsif options[:test_framework] == "minispec"
      copy_file 'templates/autotest-minispec/discover.rb', "#{name}/autotest/discover.rb"
      copy_file 'templates/autotest-minispec/.autotest', "#{name}/.autotest"
      template 'templates/autotest-minispec/spec_helper.tt', "#{name}/spec/spec_helper.rb"
      template 'templates/spec.tt', "#{name}/spec/#{name}_spec.rb"

    # RSpec
    else
      copy_file 'templates/autotest-rspec/.rspec', "#{name}/.rspec"
      copy_file 'templates/autotest-rspec/discover.rb', "#{name}/autotest/discover.rb"
      copy_file 'templates/autotest-rspec/.autotest', "#{name}/.autotest"
      template 'templates/autotest-rspec/spec_helper.tt', "#{name}/spec/spec_helper.rb"
      template 'templates/spec.tt', "#{name}/spec/#{name}_spec.rb"
    end
  end
end

class String
  def camelize(uppercase_first_letter = true)
    string = self.to_s
    if uppercase_first_letter
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
    else
      string = string.sub(/^(?:#{inflections.acronym_regex}(?=\b|[A-Z_])|\w)/) { $&.downcase }
    end
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{inflections.acronyms[$2] || $2.capitalize}" }.gsub('/', '::')
  end
end