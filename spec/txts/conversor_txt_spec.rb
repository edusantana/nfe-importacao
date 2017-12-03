require 'rails_helper'

RSpec.describe ConversorTxt do
  
  describe  "#convert_to_txt", :txt do
    let(:c){ConversorTxt.new(nota)}
    
    context 'Com uma nota com planilha e cálculos realizados' do
      let(:nota){create(:nota, planilha_itens: arquivo('joao/planilha_itens.ods'))}
      let(:txt_esperado){file_fixture("joao/nota-txt-exportada.txt").read}

      before do
        nota.calcula
      end

      it 'gera o conteúdo TXT de acordo com layout TXT NF-e v3.10.1 apropriadamente' do
        expect(c.convert_to_txt).to eq(txt_esperado)
      end
    end

  end


end
