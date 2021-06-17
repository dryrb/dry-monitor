# frozen_string_literal: true

source "https://rubygems.org"

eval_gemfile "Gemfile.devtools"

gemspec

gem "dry-configurable", github: "dry-rb/dry-configurable", branch: "master"
gem "dry-events", github: "dry-rb/dry-events", branch: "master"

group :test do
  gem "rack"
end

group :tools do
  gem "byebug", platform: :mri
end
