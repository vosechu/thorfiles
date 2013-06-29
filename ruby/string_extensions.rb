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