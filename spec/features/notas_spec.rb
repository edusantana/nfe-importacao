require 'rails_helper'

RSpec.feature "Notas", type: :feature do
  

  RSpec.feature "Exportação de TXT", type: :feature do

    background do
      dado_existe_usuario_com_uma_nota_cadastrada(:joao)
    end

    scenario 'Exportar TXT da nota' do
      quando_usuario_logar_no_sistema
      e_clicar_em_criar_nota
      e_preencher_titulo_da_nota
      e_anexar_planilha_de_itens
      e_salvar_nota
      e_clicar_para_exportar_para_txt
    end
  end


end
