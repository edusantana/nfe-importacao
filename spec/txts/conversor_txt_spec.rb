require 'rails_helper'

RSpec.describe ConversorTxt do
  
  

  describe  "#ler_txt e #escreve_txt" do
    let(:c){ConversorTxt.new(nota)}
    
    context 'Dado um TXT gerado pelo sistema distribuído pelo sebrae, versão X.Y' do
      let(:conteudo_txt_original){file_fixture("joao/joao1/nota-txt-rascunho-para-importacao-no-programa.txt").read}
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

  describe '#campos_txt', txt: :campos do
    context 'Quando conteúdo txt só tem uma linha' do
      let(:hash){ConversorTxt.campos_txt(conteudo_txt)}
      context 'Linha B' do
        let(:conteudo_txt){'B|28||COMPRA PARA COMERCIALIZACAO|0|55|1|7692|2017-10-17T01:00:00-02:00||0|3||1|1||1|1|0|2|3|3.20.55|||'}
        it 'apresenta os campos e seus valores associados para o layout 3.1.0' do
          byebug
          expect(hash['3.1.0']).not_to be_empty
          expect(hash['3.10.1']).not_to be_empty
        end
      end
    end
  end

end
