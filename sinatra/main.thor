require "thor"

class Sinatra < Thor::Group # Thor::Group executes all methods at the same time
  include Thor::Actions

  # This will make template write into the directory where the thor command was issued
  def self.source_root
    File.dirname(__FILE__)
  end

  desc "generate a simple sinatra config"
  argument :name

  def create_template_files
    Dir.glob("templates/**", File::FNM_DOTMATCH) do |file|
      next if file == 'templates/.' || file == 'templates/..'
      # puts file, "#{name}/#{File.basename(file)}"
      copy_file file, "#{name}/#{File.basename(file)}"
    end
  end
end