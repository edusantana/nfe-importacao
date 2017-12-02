require 'rails_helper'

RSpec.describe Nota, type: :model do
  

  describe '#user' do
    context 'Uma nota deve pertencer a um usuário', :wip do
      #let(:user){create(:user)}
      it 'Não é possível salvar nota sem usuário' do
        n = Nota.new(titulo: 'titulo qualquer')
        expect {n.save}.to raise_error
        expect(n.id).to be_nil
      end
    end
  end


  describe '#planilha_itens' do
    let(:nota){create(:nota)}
    context 'Aceita planilha ods' do
      let(:planilha){arquivo("joao/planilha_itens.ods")}
      before do
        nota.planilha_itens = planilha
      end
      it 'retorna a planilha' do
        expect(nota.planilha_itens).not_to be_nil
      end
    end
    context 'Não aceita planilha csv' do
      let(:planilha){arquivo("joao/planilha_itens.csv")}
      it 'retorna a planilha' do
        pending 'falta aprender a validar'
        nota.planilha_itens = planilha
        expect {nota.save}.to raise_error
      end
    end
  end
  
  describe '#calcula' do
    let(:nota){create(:nota, planilha_itens: arquivo('joao/planilha_itens.ods'), cambio: 3.1674)}
    context 'Depois que as planilhas foram inseridas' do
      before do
      end
      it 'calcula os valores dos itens e salva os resultados no hash dados' do
        expect(nota.itens).to be_nil
        nota.calcula
        expect(nota.itens[0]).to include(item: 'item1',
          preco_unitario_moeda_estrangeira: 5.0,
          quatidade: 5.0,
          valor_aduaneiro_moeda_estrangeira: 25.0,
          valor_aduaneiro_em_reais: 79.19,
          despesas_aduaneiras: 58.75,
          bc2: 137.93 ,
          percetual2: 0.18,
          valor2: 24.83,
          bc_ipi:  162.76
        )
      end
    end
  end


  describe '#to_txt' do
    context 'Convertendo nota modelo do joão' do
      let(:nota){create(:nota, planilha_itens: arquivo('joao/planilha_itens.ods'))}
      let(:txt_esperado){file_fixture("joao/nota-txt-exportada.txt").read}
      it 'exporta a nota para o format TXT' do
        expect(nota.to_txt).to eq(txt_esperado)
      end

    end
  end

end
