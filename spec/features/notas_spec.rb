require 'rails_helper'

RSpec.feature "Notas", type: :feature do
  
  feature 'Criação de nota' do

    background do
      dado_um_usuario_logado
    end

    scenario 'Envio de planilha com os dados', :wip do
      quando_usuario_estiver_na_pagina_de_notas
      e_clicar_em_criar_nota
      e_preencher_titulo_da_nota
      e_anexar_planilha
      e_salvar_nota
      entao_a_nota_foi_salva
    end
    

  end

  feature "Exportação de TXT", type: :feature do

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

  def dado_um_usuario_logado
    @usuario = create(:user)
    login_as(@usuario)
  end

  def quando_usuario_estiver_na_pagina_de_notas
    visit notas_path
  end

  def e_clicar_em_criar_nota
    click_on('Nova nota')
  end

  def e_preencher_titulo_da_nota
    @titulo = build(:nota).titulo
    fill_in('nota[titulo]', with: @titulo)
  end

  def e_anexar_planilha
    attach_file 'nota[planilha_itens]', '/home/dudu/Dropbox/startup/nfe/exemplo-joao/nfdi_171660795-9.xls' #arquivo('joao/itens-joao.xls')
  end

  def entao_a_nota_foi_salva
    nota = Nota.find_by!(:titulo => @titulo)
    expect(nota).not_to be_nil
    expect(nota.planilha_itens.present?).to be true
  end

  def e_salvar_nota
    click_on('Salvar')
  end

end
