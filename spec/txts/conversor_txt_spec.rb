require 'rails_helper'

RSpec.describe ConversorTxt do
  


  describe  "#ler_txt e #escreve_txt" do
    let(:c){ConversorTxt.new(nota)}
    
    context 'Dado um TXT gerado pelo sistema distribuído pelo sebrae, versão X.Y' do
      let(:conteudo_txt_original){file_fixture("joao/joao1/nota-txt-exportada.txt").read}
      let(:conversor){ConversorTxt.new}
      
      context 'depois do conteúdo do TXT ter sido interpretado' do
        before do
          conversor.interpreta_conteudo_txt(conteudo_txt_original)
        end

        it 'foi gerada uma estrutura contendo os dados do TXT' do
          expect(conversor.dados).not_to be_empty
        end

        it 'com essa estrutura gera-se um conteúdo identico ao do txt original', :txt do
          expect(conversor.escreve_conteudo_txt).to eq(conteudo_txt_original)
        end

        # conteúdo gerado de acordo  com layout TXT NF-e v3.10.1 apropriadamente
        
      end
    end

  end


end
