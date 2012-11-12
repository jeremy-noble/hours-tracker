# Check for an <a> tag with the exact text and optional :href and  :count.
# Same param syntax as has_link, but it only matches the link's TEXT, not id,
# label, etc., and it doesn't match substrings.
def has_exact_link?(locator, options={})

  # Subtract :href, :count from array of options.keys
  # Raise error if any options remain
  raise ArgumentError.new \
    "options, if supplied, must be a hash" if !options.is_a?(Hash)
  raise ArgumentError.new \
    "has_exact_link only supports 'href' and 'count' as options" unless
    (options.keys - [:href] - [:count]).empty?
  href = options[:href]
  xpath = href ? "//a[normalize-space(text())='#{locator}' and @href='#{href}']" :
                 "//a[normalize-space(text())='#{locator}']/@href"
  # pass original options has so test results will show options if present
  # has_xpath apparently ignores :href in options but will use :count.
  has_xpath?(xpath, options)

end


RSpec::Matchers.define :appear_before do |later_content|
  match do |earlier_content|
    page.body.index(earlier_content) < page.body.index(later_content)
  end
end