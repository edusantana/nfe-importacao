class Nota < ApplicationRecord
  belongs_to :user
  has_attached_file :planilha_itens
  validates_attachment :planilha_itens, content_type: { content_type: ['application/vnd.oasis.opendocument.spreadsheet', 'application/vnd.ms-excel'] }
  
  attr_accessor :cambio
  attr_accessor :itens
  attr_accessor :dados
  
  
  def calcula
    calculo = NotaPlanilhaCalculo.new(self)
    
    
  end
  
  def to_txt
    txt = IO.read('/home/dudu/w/nfe-espelho/spec/fixtures/files/joao/nota-txt-exportada.txt')
#    txt.strip.gsub(/\n/, "\r\n")
  end
  
end
