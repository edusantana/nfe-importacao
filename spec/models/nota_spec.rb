require 'rails_helper'

RSpec.describe Nota, type: :model do
  

  describe '#user' do
    context 'Uma nota deve pertencer a um usuário' do
      #let(:user){create(:user)}
      it 'Não é possível salvar nota sem usuário' do
        pending 'Não sei pq não emite erro, não é importante no momento'
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
    let(:nota){create(:nota, planilha_itens: arquivo('joao/planilha_itens.ods'))}
    context 'Depois que as planilhas foram inseridas' do
      before do
      end
      it 'calcula os valores dos itens e salva os resultados no hash dados' do
        expect(nota.dados).to be_nil
        nota.calcula
        expect(nota.dados['totais']['total_nf']).to be_within(0.03).of( 6_789.62 )
      end
    end
  end


  describe '#to_txt', :txt do
    let(:nota){create(:nota, planilha_itens: arquivo("joao/#{input_dir}/planilha_itens.ods"))}
    let(:txt_esperado){file_fixture("joao/#{input_dir}/nota-txt-rascunho-para-importacao-no-programa.txt").read}
    let(:temp_file_para_depuracao){"tmp/#{input_dir}-nota-txt-gerada-no-ultimo-teste.txt"}

    before do
      nota.calcula
      IO.write(temp_file_para_depuracao, nota.to_txt) 
    end

    context 'Quando invocado sobre uma nota com planilha calculada (ex: nota de joão)', :joao => 1 do
      let(:input_dir){'joao1'}
      it 'exporta a nota para o format TXT' do
        expect(nota.to_txt).to eq(txt_esperado)
      end

    end

    context 'Quando invocado sobre uma nota com planilha calculada (ex: nota2 de joão)', :joao => 2 do
      let(:input_dir){'joao2'}
      it 'exporta a nota para o format TXT para importação como rascunho pelo sistema' do
        expect(nota.to_txt).to eq(txt_esperado)
      end

    end

  end

end
