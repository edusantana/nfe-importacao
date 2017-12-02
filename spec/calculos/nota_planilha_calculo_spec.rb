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

        expect(dados['itens'][0]['valor_aduaneiro_em_modea_estrangeira']).to eq(25.0)
        expect(dados['itens'][12]['valor_aduaneiro_em_modea_estrangeira']).to eq(21.0)

        expect(dados['totais']['valor_aduaneiro_em_modea_estrangeira']).to eq(710.0)

        expect(dados['cambio']).to eq(3.1674)

        expect(dados['itens'][0]['valor_aduaneiro_em_reais']).to be_within(0.01).of(79.19)
        expect(dados['itens'][12]['valor_aduaneiro_em_reais']).to be_within(0.01).of(66.52)

        expect(dados['totais']['valor_aduaneiro_em_reais']).to be_within(0.01).of(2248.85)

        expect(dados['totais']['despesas_aduaneiras']).to eq(1668.46)
        
        expect(dados['itens'][0]['despesas_aduaneiras']).to be_within(0.01).of(58.75)
        expect(dados['itens'][12]['despesas_aduaneiras']).to be_within(0.01).of(49.35)
        
        expect(dados['itens'][0]['BC_II']).to be_within(0.01).of(137.93)
        expect(dados['itens'][12]['BC_II']).to be_within(0.01).of(115.86)
        
        
        expect(dados['itens'][0]['II']).to eq(0.18)
        expect(dados['itens'][12]['II']).to eq(0.18)
        
        expect(dados['itens'][0]['valor_II']).to be_within(0.01).of(24.83)
        expect(dados['itens'][12]['valor_II']).to be_within(0.01).of(20.86)

        expect(dados['totais']['valor_II']).to be_within(0.01).of(705.11)

        expect(dados['itens'][0]['BC_IPI']).to be_within(0.01).of( 162.76 )
        expect(dados['itens'][12]['BC_IPI']).to be_within(0.01).of( 136.72 )

        expect(dados['itens'][0]['IPI']).to be_within(0.01).of( 0.05 )
        expect(dados['itens'][12]['IPI']).to be_within(0.01).of( 0.05 )

        
        expect(dados['itens'][0]['valor_IPI']).to  be_within(0.01).of( 8.14 )
        expect(dados['itens'][12]['valor_IPI']).to be_within(0.01).of( 6.84 )
        
        expect(dados['totais']['valor_IPI']).to be_within(0.01).of(231.12)
        

        expect(dados['itens'][0]['BC_PIS_COFINS']).to  be_within(0.01).of( 137.93 )
        expect(dados['itens'][12]['BC_PIS_COFINS']).to be_within(0.01).of( 115.86 )
        #expect(dados['totais']['BC_PIS_COFINS']).to be_within(0.01).of(3917.31)
        
        
        
        
        

      end

    end

  end


end
