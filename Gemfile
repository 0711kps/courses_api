source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'rails', '7.0.3'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webrick', '1.7'
gem 'jwt', '2.4.0'

group :development do
  gem 'standard', '1.12.1'
end

group :development, :test do
  gem 'pry-rails', '0.3.9'
end

group :test do
  gem 'rspec-rails', '5.1.2'
end
