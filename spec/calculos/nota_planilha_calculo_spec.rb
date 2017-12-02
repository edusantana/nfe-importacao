require 'rails_helper'

RSpec.describe NotaPlanilhaCalculo do
  

  describe  "#calcula" do
    let(:c){NotaPlanilhaCalculo.new(nota)}
    
    context 'Quando nota possui planilha anexada', :calculo do
      let(:nota){create(:nota, planilha_itens: arquivo('joao/planilha_itens.ods'))}

      before do
        expect(nota.planilha_itens).not_to be_nil
        expect(File.exist?(nota.planilha_itens.path)).to be true
      end

      it 'calcula os valores para nota fiscal baseados na planilha e retorna em um hash' do
        dados = c.calcula
        expect(dados).not_to be_empty
        expect(dados['itens'].size).to eq(22)
        expect(dados['itens']).not_to be_empty
        expect(dados['itens'][0]).not_to include('Item'=>'Item')

        expect(dados['valor_aduaneiro_em_modea_estrangeira'][0]).to eq(25.0)
        expect(dados['valor_aduaneiro_em_modea_estrangeira'][12]).to eq(21.0)

        expect(dados['totais']['valor_aduaneiro_em_modea_estrangeira']).to eq(710.0)

        expect(dados['cambio']).to eq(3.1674)

        expect(dados['valor_aduaneiro_em_reais'][0]).to be_within(0.01).of(79.19)
        expect(dados['valor_aduaneiro_em_reais'][12]).to be_within(0.01).of(66.52)

        expect(dados['totais']['valor_aduaneiro_em_reais']).to be_within(0.01).of(2248.85)
        
        
        
        
        

      end

    end

  end


end
