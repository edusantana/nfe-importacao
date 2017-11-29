require 'rails_helper'

RSpec.describe Nota, type: :model do
  


  describe '#planilha_itens' do
    context 'Quando anexamos uma planilha csv' do
      let(:nota){create(:nota)}
      let(:planilha){arquivo("joao/planilha_itens.csv")}
      
      before do
        nota.planilha_itens = planilha
      end

      it 'retorna a planilha' do
        expect(nota.planilha_itens).not_to be_nil
      end



    end
  end


  describe '#to_txt' do
    context 'Convertendo nota modelo do joão' do
      let(:nota){create(:nota)}
      let(:txt_esperado){file_fixture("notas/joao/nota-txt-exportada.txt")}

      before do

      end

      it 'exporta a nota para o format TXT' do
        expect(nota.to_txt).to eq(txt_esperado)
      end

    end
  end

end
