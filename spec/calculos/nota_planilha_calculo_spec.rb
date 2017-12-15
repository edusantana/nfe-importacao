require 'rails_helper'
require 'fileutils'
require 'roo'



RSpec.describe NotaPlanilhaCalculo do

  before(:all) do
    FileUtils.mkdir_p 'tmp/calculos'    
  end

  describe  "#calcula" do
    let(:c){NotaPlanilhaCalculo.new(nota)}
    
    context 'Quando nota possui planilha anexada', :calculo do
      
      before do
        expect(nota.planilha_itens).not_to be_nil
        expect(File.exist?(nota.planilha_itens.path)).to be true
      end
      
      context 'tomando a planilha de joão como exemplo' do
        let(:nota){create(:nota, planilha_itens: arquivo('joao/joao1/planilha_itens.ods'))}
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
          
          expect(dados['itens'][0]['despesas_aduaneiras']).to  be_within(0.01).of(58.75)
          expect(dados['itens'][12]['despesas_aduaneiras']).to be_within(0.01).of(49.35)
          
          expect(dados['itens'][0]['BC_II']).to  be_within(0.01).of(137.93)
          expect(dados['itens'][12]['BC_II']).to be_within(0.01).of(115.86)
          
          
          expect(dados['itens'][0]['II']).to  eq(0.18)
          expect(dados['itens'][12]['II']).to eq(0.18)
          
          expect(dados['itens'][0]['valor_II']).to be_within(0.01).of(24.83)
          expect(dados['itens'][12]['valor_II']).to be_within(0.01).of(20.86)

          expect(dados['totais']['valor_II']).to be_within(0.01).of(705.11)

          expect(dados['itens'][0]['BC_IPI']).to  be_within(0.01).of( 162.76 )
          expect(dados['itens'][12]['BC_IPI']).to be_within(0.01).of( 136.72 )

          expect(dados['itens'][0]['IPI']).to  be_within(0.01).of( 0.05 )
          expect(dados['itens'][12]['IPI']).to be_within(0.01).of( 0.05 )

          
          expect(dados['itens'][0]['valor_IPI']).to  be_within(0.01).of( 8.14 )
          expect(dados['itens'][12]['valor_IPI']).to be_within(0.01).of( 6.84 )
          
          expect(dados['totais']['valor_IPI']).to be_within(0.01).of(231.12)
          

          expect(dados['itens'][0]['BC_PIS_COFINS']).to  be_within(0.01).of( 137.93 )
          expect(dados['itens'][12]['BC_PIS_COFINS']).to be_within(0.01).of( 115.86 )
          expect(dados['totais']['BC_PIS_COFINS']).to    be_within(0.01).of( 3917.31)


          expect(dados['itens'][0]['PIS']).to  eq( 0.021 )
          expect(dados['itens'][12]['PIS']).to eq( 0.021 )

          expect(dados['itens'][0]['valor_PIS']).to  be_within(0.01).of( 2.90  )
          expect(dados['itens'][12]['valor_PIS']).to be_within(0.01).of( 2.43  )
          expect(dados['totais']['valor_PIS']).to be_within(0.01).of(82.26)

          expect(dados['itens'][0]['COFINS']).to  eq(0.1065)
          expect(dados['itens'][12]['COFINS']).to eq(0.1065)

          expect(dados['itens'][0]['valor_COFINS']).to  be_within(0.01).of( 14.69 )
          expect(dados['itens'][12]['valor_COFINS']).to be_within(0.01).of( 12.34 )
          expect(dados['totais']['valor_COFINS']).to be_within(0.01).of(417.19)
        
          
          expect(dados['itens'][0]['valor_total_produto']).to  be_within(0.01).of(79.19)
          expect(dados['itens'][12]['valor_total_produto']).to be_within(0.01).of(66.52)
          expect(dados['totais']['valor_total_produto']).to be_within(0.01).of(2_248.85)
          
          expect(dados['itens'][0]['valor_unitario_real']).to  be_within(0.000001).of(15.837000)
          expect(dados['itens'][12]['valor_unitario_real']).to be_within(0.000001).of(6.651540)
          
          expect(dados['itens'][0]['rateio_despesas_acessorias']).to  be_within(0.0000001).of(0.03521133024)
          expect(dados['itens'][12]['rateio_despesas_acessorias']).to be_within(0.0000001).of(0.02957751740)
          expect(dados['totais']['rateio_despesas_acessorias']).to be_within(0.0000001).of(1.0)
          
          expect(dados['itens'][0]['despesas_acessorias']).to  be_within(0.0001).of(7.5528303)
          expect(dados['itens'][12]['despesas_acessorias']).to be_within(0.0001).of(6.3443775)
          expect(dados['totais']['despesas_acessorias']).to be_within(0.0001).of(214.50)
          
          expect(dados['itens'][0]['ICMS']).to  eq(0.18)
          expect(dados['itens'][12]['ICMS']).to eq(0.18)

          expect(dados['itens'][0]['valor_ICMS']).to  be_within(0.01).of(43.03)
          expect(dados['itens'][12]['valor_ICMS']).to be_within(0.01).of(36.15)
          expect(dados['totais']['valor_ICMS']).to be_within(0.01).of(1_222.13)
          
          expect(dados['itens'][0]['BC_ICMS_FINAL']).to  be_within(0.01).of( 239.07 )
          expect(dados['itens'][12]['BC_ICMS_FINAL']).to be_within(0.01).of( 200.82 )
          expect(dados['totais']['BC_ICMS_FINAL']).to be_within(0.01).of(6_789.65)
          
          expect(dados['itens'][0]['total_despesas_acessorias']).to  be_within(0.01).of( 126.92 )
          expect(dados['itens'][12]['total_despesas_acessorias']).to be_within(0.01).of( 106.61 )
          expect(dados['totais']['total_despesas_acessorias']).to be_within(0.01).of(3_604.55)

          expect(dados['itens'][0]['total_despesas_sem_frete']).to  be_within(0.01).of( 68.17 )
          expect(dados['itens'][12]['total_despesas_sem_frete']).to be_within(0.01).of( 57.26 )
          expect(dados['totais']['total_despesas_sem_frete']).to be_within(0.01).of(1_936.09)

          expect(dados['itens'][0]['total_frete']).to  be_within(0.01).of( 58.75 )
          expect(dados['itens'][12]['total_frete']).to be_within(0.01).of( 49.35 )
          expect(dados['totais']['total_frete']).to be_within(0.01).of(1_668.46 )
          
          expect(dados['itens'][0]['ICMS_final']).to  be_within(0.01).of( 43.03 )
          expect(dados['itens'][12]['ICMS_final']).to be_within(0.01).of( 36.15 )
          expect(dados['totais']['ICMS_final']).to be_within(0.01).of( 1_222.13 )
          
          expect(dados['totais']['total_nf']).to be_within(0.03).of( 6_789.62 )
          
          # Salva dados como json para inspeção:
          open('spec/fixtures/files/joao/joao1/dados.json', 'w') { |f| f << JSON.pretty_generate(dados) } 

        end
      end

      context 'tomando a planilha 2 de joão como exemplo', :calculo do
        let(:nota){create(:nota, planilha_itens: arquivo('joao/joao2/planilha_itens.ods'))}
        it 'calcula os valores para nota fiscal baseados na planilha e retorna em um hash' do
          dados = c.calcula
          expect(dados['totais']['total_nf']).to be_within(0.04).of( 6_520.00 )

          #Salva dados como json para inspeção:
          open('tmp/joao2-dados.json', 'w') { |f| f << JSON.pretty_generate(dados) } 

        end
      end

      context 'tomando a planilha 5 de joão como exemplo', :calculo => :auto5 do
        let(:base){ Roo::Spreadsheet.open('spec/fixtures/files/exemplos-do-joao/notafiscal5.xlsx')} # base
        let(:nota){create(:nota, planilha_itens: arquivo('exemplos-do-joao/notafiscal5-planilha.ods'))}
        let(:n){19}
        let(:offset){9} # deslocamento na base original

        it 'calcula os valores para nota fiscal baseados na planilha e retorna em um hash' do
          dados = c.calcula
          expect(dados).not_to be_empty

          # for debug
          open('tmp/calculos/exemplos-do-joao-notafiscal5-planilha.json', 'w') { |f| f << JSON.pretty_generate(dados) } 

          expect(dados['itens'].size).to eq(19)
          expect(dados['itens']).not_to be_empty
          expect(dados['itens'][0]).not_to include('Item'=>'Item')

          expect(dados['itens'][0]['valor_aduaneiro_em_modea_estrangeira']).to eq(16.05)
          expect(dados['itens'][12]['valor_aduaneiro_em_modea_estrangeira']).to eq(69)
          
          chave = 'valor_aduaneiro_em_modea_estrangeira'
          expect(dados['itens'][0][chave]).to eq(base.e10)
          expect(dados['itens'][12][chave]).to eq(base.e22)

          expect(dados['totais']['valor_aduaneiro_em_modea_estrangeira']).to be_within(0.01).of(725.90)
          expect(dados['totais']['valor_aduaneiro_em_modea_estrangeira']).to be_within(0.01).of(base.e39)

          expect(dados['cambio']).to eq(3.1572)
          expect(dados['cambio']).to eq(base.f4)

          expect(dados['itens'][0]['valor_aduaneiro_em_reais']).to be_within(0.01).of(50.67)
          expect(dados['itens'][12]['valor_aduaneiro_em_reais']).to be_within(0.01).of(217.85)

          expect(dados['totais']['valor_aduaneiro_em_reais']).to be_within(0.01).of(2291.81)

          expect(dados['totais']['despesas_aduaneiras']).to eq(1531.75)
          
          expect(dados['itens'][0]['despesas_aduaneiras']).to  be_within(0.01).of(33.87)
          expect(dados['itens'][12]['despesas_aduaneiras']).to be_within(0.01).of(145.60)
          
          expect(dados['itens'][0]['BC_II']).to  be_within(0.01).of(84.54)
          expect(dados['itens'][12]['BC_II']).to be_within(0.01).of(363.45)
          
          
          expect(dados['itens'][0]['II']).to  eq(0.18)
          expect(dados['itens'][12]['II']).to eq(0.18)
          
          expect(dados['itens'][0]['valor_II']).to be_within(0.01).of(15.22)
          expect(dados['itens'][12]['valor_II']).to be_within(0.01).of(65.42)

          expect(dados['totais']['valor_II']).to be_within(0.01).of(688.24)

          expect(dados['itens'][0]['BC_IPI']).to  be_within(0.01).of( 99.76 )
          expect(dados['itens'][12]['BC_IPI']).to be_within(0.01).of( 428.87)

          expect(dados['itens'][0]['IPI']).to  be_within(0.01).of( 0.05 )
          expect(dados['itens'][12]['IPI']).to be_within(0.01).of( 0.05 )

          
          expect(dados['itens'][0]['valor_IPI']).to  be_within(0.01).of( 4.99 )
          expect(dados['itens'][12]['valor_IPI']).to be_within(0.01).of( 21.44)
          
          expect(dados['totais']['valor_IPI']).to be_within(0.01).of(225.59)
          

          expect(dados['itens'][0]['BC_PIS_COFINS']).to  be_within(0.01).of( 84.54   )
          expect(dados['itens'][12]['BC_PIS_COFINS']).to be_within(0.01).of( 363.45  )
          expect(dados['totais']['BC_PIS_COFINS']).to    be_within(0.01).of( 3_823.56 )


          expect(dados['itens'][0]['PIS']).to  eq( 0.0312 )
          expect(dados['itens'][12]['PIS']).to eq( 0.0312 )
          
          expect(dados['itens'][0]['valor_PIS']).to  be_within(0.01).of( 2.64 )
          expect(dados['itens'][12]['valor_PIS']).to be_within(0.01).of( 11.34  )
          expect(dados['totais']['valor_PIS']).to be_within(0.01).of(119.29 )
       
          expect(dados['itens'][0]['COFINS']).to  eq(0.1537)
          expect(dados['itens'][12]['COFINS']).to eq(0.1537)

          
          

          expect(dados['itens'][0]['valor_COFINS']).to  be_within(0.01).of( 12.99 )
          expect(dados['itens'][12]['valor_COFINS']).to be_within(0.01).of( 55.86 )
          expect(dados['totais']['valor_COFINS']).to be_within(0.01).of(587.68)
        
          
          expect(dados['itens'][0]['valor_total_produto']).to  be_within(0.01).of(50.67 )
          expect(dados['itens'][12]['valor_total_produto']).to be_within(0.01).of(217.85)
          expect(dados['totais']['valor_total_produto']).to be_within(0.01).of(2_291.81 )
          
          expect(dados['itens'][0]['valor_unitario_real']).to  be_within(0.000001).of(10.134612)
          expect(dados['itens'][12]['valor_unitario_real']).to be_within(0.000001).of(7.261560)
          
          expect(dados['itens'][0]['rateio_despesas_acessorias']).to  be_within(0.0001).of(0.0221)
          expect(dados['itens'][12]['rateio_despesas_acessorias']).to be_within(0.0001).of(0.0951)
          expect(dados['totais']['rateio_despesas_acessorias']).to be_within(0.0000001).of(1.0)
          
          expect(dados['itens'][0]['despesas_acessorias']).to  be_within(0.0001).of(13.1968717          )
          expect(dados['itens'][12]['despesas_acessorias']).to be_within(0.0001).of(56.7342149          )
          expect(dados['totais']['despesas_acessorias']).to be_within(0.0001).of(596.86)
          
          expect(dados['itens'][0]['ICMS']).to  eq(0.18)
          expect(dados['itens'][12]['ICMS']).to eq(0.18)

          expect(dados['itens'][0]['valor_ICMS']).to  be_within(0.01).of(29.32          )
          expect(dados['itens'][12]['valor_ICMS']).to be_within(0.01).of(126.05)
          expect(dados['totais']['valor_ICMS']).to be_within(0.01).of(1_326.12 )
          
          expect(dados['itens'][0]['BC_ICMS_FINAL']).to  be_within(0.01).of( 162.90          )
          expect(dados['itens'][12]['BC_ICMS_FINAL']).to be_within(0.01).of( 700.30          )
          expect(dados['totais']['BC_ICMS_FINAL']).to be_within(0.01).of(7_367.35          )
          
          expect(dados['itens'][0]['total_despesas_acessorias']).to  be_within(0.01).of( 92.02          )
          expect(dados['itens'][12]['total_despesas_acessorias']).to be_within(0.01).of( 395.59          )
          expect(dados['totais']['total_despesas_acessorias']).to be_within(0.01).of(4_161.71)

          expect(dados['itens'][0]['total_despesas_sem_frete']).to  be_within(0.01).of( 58.15          )
          expect(dados['itens'][12]['total_despesas_sem_frete']).to be_within(0.01).of( 249.99          )
          expect(dados['totais']['total_despesas_sem_frete']).to be_within(0.01).of(2_629.96
          )

          expect(dados['itens'][0]['total_frete']).to  be_within(0.01).of( 33.87          )
          expect(dados['itens'][12]['total_frete']).to be_within(0.01).of( 145.60 )
          expect(dados['totais']['total_frete']).to be_within(0.01).of(1_531.75          )
          
          expect(dados['itens'][0]['ICMS_final']).to  be_within(0.01).of( 29.32          )
          expect(dados['itens'][12]['ICMS_final']).to be_within(0.01).of( 126.05          )
          expect(dados['totais']['ICMS_final']).to be_within(0.01).of( 1_326.12          )
          
          expect(dados['totais']['total_nf']).to be_within(0.03).of( 7_367.34          )
          

        end
      end



    end

  end


end
