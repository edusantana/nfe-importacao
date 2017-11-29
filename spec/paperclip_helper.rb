RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

def arquivo(file)
  File.new("#{Rails.root}/spec/fixtures/files/#{file}")
end