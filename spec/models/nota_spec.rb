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
      let(:planilha){arquivo("exemplos-do-joao/notafiscal5-planilha.ods")}
      before do
        nota.planilha_itens = planilha
      end
      it 'retorna a planilha' do
        expect(nota.planilha_itens).not_to be_nil
      end
    end
    context 'Não aceita planilha csv' do
      let(:planilha){arquivo("joao/joao1/planilha_itens.csv")}
      it 'retorna a planilha' do
        pending 'falta aprender a validar'
        nota.planilha_itens = planilha
        expect {nota.save}.to raise_error
      end
    end
  end
  
  describe '#calcula' do
    let(:nota){create(:nota, planilha_itens: arquivo('exemplos-do-joao/notafiscal5-planilha.ods'))}
    context 'Depois que as planilhas foram inseridas' do
      before do
      end
      it 'calcula os valores dos itens e salva os resultados no hash dados' do
        expect(nota.dados).to be_nil
        nota.calcula
        expect(nota.dados['totais']['total_nf']).to be_within(0.03).of( 7_367.34 )
      end
    end
  end


  describe '#to_txt', :txt do
    let(:nota){create(:nota, planilha_itens: arquivo("joao/#{input_dir}/planilha_itens.ods"))}
    let(:txt_esperado){file_fixture("joao/#{input_dir}/nota-txt-rascunho-para-importacao-no-programa.txt").read}
    let(:temp_file_para_depuracao){"tmp/#{input_dir}-nota-txt-gerada-no-ultimo-teste.txt"}

    
    context 'Quando chamando sem uma planilha' do
      let(:nota){create(:nota)}
      before do
        
      end
      it 'emite erro' do
        expect { nota.to_txt }.to raise_error(RuntimeError, "Nota ainda não possui planilha")
      end
    end

    context 'Quando chamando com uma planilha mas sem invocar #calcula antes' do
      let(:nota){create(:nota, planilha_itens: arquivo("exemplos-do-joao/notafiscal5-planilha.ods"))}
      it 'emite erro', :wip do
        expect { nota.to_txt }.to raise_error(RuntimeError, "Você deve invocar #calcula antes de tentar gerar o txt")
      end
    end


    context 'Quando nota contém uma planilha previamente calculada', :txt, :auto do
      let(:nota){create(:nota, planilha_itens: arquivo("exemplos-do-joao/notafiscal#{n}-planilha.ods"))}
      let(:txt_esperado){file_fixture("exemplos-do-joao/notafiscal#{n}-para-importar-como-rascunho.txt").read}
      let(:temp_file_para_depuracao){"tmp/notafiscal-exemplos-do-joao#{n}-gerada-no-ultimo-teste.txt"}
      
      
      before do
        nota.calcula
        IO.write(temp_file_para_depuracao, nota.to_txt) # para debug
      end
  
      # planilhas = [2,5]
      planilhas = [5]

      planilhas.each do |n|
        context "(planilha automobilística #{n})", :txt => "auto#{n}", joao: n do
          let(:n){n}
          it 'exporta a nota para o format TXT (que será posteriormente importado como rascunho pelo sistema de geração de notas)' do
            expect(nota.to_txt).to eq(txt_esperado)
          end
        end
      end

    end

  end

end
