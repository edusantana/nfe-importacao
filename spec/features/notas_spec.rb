require 'rails_helper'

RSpec.feature "Notas", type: :feature do
  
  feature 'Criação de nota' do

    background do
      dado_um_usuario_logado
    end

    scenario 'Envio de planilha com os dados' do
      quando_usuario_estiver_na_pagina_de_notas
      e_clicar_em_criar_nota
      e_preencher_titulo_da_nota
      e_anexar_planilha
      e_salvar_nota
      entao_a_nota_foi_salva
    end
    

  end

  # https://stackoverflow.com/questions/10122130/how-to-generate-a-text-file-from-a-string-for-download-in-ruby-on-rails
  # http://api.rubyonrails.org/classes/ActionController/DataStreaming.html#method-i-send_data
  # https://stackoverflow.com/questions/8662250/how-do-i-create-a-temp-file-and-write-to-it-then-allow-users-to-download-it
  feature "Exportação de TXT", type: :feature do

    background do
      dado_existe_usuario_com_uma_nota_cadastrada
      e_usuario_esta_logado
    end

    scenario 'Exportar TXT da nota' do
      pending 'Aguardando conversão funcionar'
      quando_usuario_estiver_na_pagina_de_notas
      e_clicar_em_criar_nota
      e_preencher_titulo_da_nota
      e_anexar_planilha
      e_salvar_nota
      e_clicar_para_exportar_para_txt
      #entao_um_arquivo_txt_foi_enviado
      # incrementou quantidade de txts gerados
    end
  end

  feature 'Não é possível excluir uma nota' do
    pending 'Remover destroy'
  end

  def dado_um_usuario_logado
    @usuario = create(:user)
    e_usuario_esta_logado
  end

  def e_usuario_esta_logado
    login_as(@usuario)
  end

  def dado_existe_usuario_com_uma_nota_cadastrada
    @usuario = create(:user)
    @nota = create(:nota, user: @usuario)
  end

  def quando_usuario_estiver_na_pagina_de_notas
    visit notas_path
  end

  def e_clicar_em_criar_nota
    click_on('Nova nota')
  end

  def e_clicar_para_exportar_para_txt
    click_on('Baixar TXT para gerar nota fiscal')
  end

  def e_preencher_titulo_da_nota
    @titulo = build(:nota).titulo
    fill_in('nota[titulo]', with: @titulo)
  end

  def e_anexar_planilha
    attach_file 'nota[planilha_itens]', arquivo_path('joao/joao1/itens-joao.xls')
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
