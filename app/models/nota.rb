class Nota < ApplicationRecord
  belongs_to :user

  has_attached_file :planilha_itens
  validates_attachment :planilha_itens, content_type: { content_type: 'text/plain' }
  
  
end
