RSpec::Matchers.define :have_meta_name do |name, expected|
  match do
    has_css?("meta[name='#{name}'][content='#{expected}']", visible: false)
  end

  failure_message do
    "expected that meta #{name} would exist with content='#{expected}'"
  end
end

RSpec::Matchers.define :have_meta_property do |property, expected|
  match do
    has_css?("meta[property='#{property}'][content='#{expected}']", visible: false)
  end

  failure_message do
    "expected that meta #{property} would exist with content='#{expected}'"
  end
end
