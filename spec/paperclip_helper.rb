


def arquivo(file)
  File.new arquivo_path(file)
end

def arquivo_path(file)
  Rails.root.join('spec', 'fixtures', 'files', file)
end



# Apaga arquivos de testes gerados ao anexar arquivos
# https://github.com/thoughtbot/paperclip#testing
RSpec.configure do |config|
  
  config.after(:suite) do
    #FileUtils.rm_rf(Dir["#{Rails.root}/tmp/test_files/"])
  end
  
end
