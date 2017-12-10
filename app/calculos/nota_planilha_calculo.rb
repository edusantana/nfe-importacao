require 'roo'

class NotaPlanilhaCalculo

  attr_accessor :nota
  attr_accessor :dados
  attr_accessor :planilha

  def initialize(nota)
    @nota = nota
    @dados = {}
  end

  def calcula
    ler_planilha
    calcula_valor_aduaneiro_em_modea_estrangeira
    calcula_valor_aduaneiro_em_reais
    calcula_despesas_aduaneiras
    calcula_BC_II
    calcula_valor_II
    calcula_BC_IPI
    calcula_valor_IPI
    calcula_BC_PIS_COFINS
    calcula_valor_PIS
    calcula_COFINS
    calcula_valor_total_produto
    calcula_valor_unitario_real
    calcula_rateio_despesas_acessorias
    calcula_despesas_acessorias
    calcula_valor_ICMS
    calcula_BC_ICMS_FINAL
    calcula_total_despesas_acessorias
    calcula_total_despesas_sem_frete
    calcula_total_frete
    calcula_ICMS_final
    calcula_total_nf
    
    @dados
  end
  
  private
  
  def ler_planilha
    @planilha = Roo::Spreadsheet.open(nota.planilha_itens.path) 
    dados['totais'] = {}
    ler_itens
    ler_planilha_dados
    ler_planilha_B
    ler_planilha_C
    ler_planilha_E
    ler_planilha_I
    ler_planilha_Transporte
    
  end
  
  def ler_itens
    itens = []

    sheet = @planilha.sheet('Itens')

    sheet.each(item: 'Item', II: 'II', :headers => true) do |hash|
      itens << hash
    end

    itens.delete_at(0)
    dados['itens'] = itens
  end

  def ler_planilha_dados
    sheet = @planilha.sheet('Dados')
    hash = {}
    cabecalhos = {'Câmbio' => 'cambio', 'TOTAL FRETE'=>'frete', 'TAXA DE UTILIZACAO DO SISCOMEX' => 'taxa_siscomex', 'S/REF' => 'S/REF', 'N/REF'=>'N/REF', 'DI'=>'DI', 'UF do emitente'=>'emitente_UF'}
    sheet.each do |linha|
      if cabecalhos.key? linha[0]
        key = cabecalhos[linha[0]]
      else
        key = linha[0]
      end
      hash[key] = linha[1]
    end
    dados.merge!(hash)
  end

  def ler_planilha_B
    sheet = @planilha.sheet('B')
    hash = {}
    sheet.each do |linha|
      hash[linha[0]] = linha[1]
    end
    dados.merge!({'B' => hash})
  end

  def ler_planilha_C
    sheet = @planilha.sheet('C')
    hash = {}
    sheet.each do |linha|
      hash[linha[0]] = linha[1]
    end
    dados.merge!({'C' => hash})
  end


  def ler_planilha_E
    sheet = @planilha.sheet('E')
    hash = {}
    sheet.each do |linha|
      hash[linha[0]] = linha[1]
    end
    dados.merge!({'E' => hash})
  end

  def ler_planilha_I
    sheet = @planilha.sheet('I')
    hash = {}
    sheet.each do |linha|
      camposI18 = ("nDI|dDI|xLocDesemb|UFDesemb|dDesemb|tpViaTransp|vAFRMM|tpIntermedio|CNPJ|UFTerceiro|cExportador".split '|')
      camposI25 = ("nAdicao|nSeqAdicC|cFabricante|vDescDI|nDraw".split '|')
      campos = camposI18 + camposI25

      if campos.include? linha[0]
        hash[linha[0]] = linha[1]
      end
    end
    dados.merge!({'importacao' => hash})
  end

  def ler_planilha_Transporte
    sheet = @planilha.sheet('Transporte')
    hash = {'modFrete' => sheet.a2, 'transportes' => []}
    headers = 'modFrete','qVol','esp','marca','nVol', 'pesoL','pesoB'
    sheet.each do |linha|
      hash['transportes'] << Hash[headers.zip linha]
    end
    hash['transportes'].shift # descarta cabeçalho
    dados.merge!({'transporte' => hash})    
  end

  def calcula_valor_aduaneiro_em_modea_estrangeira
    
    total = 0
    dados['itens'].each_with_index do |item,i|
      valor = item['Preço'] * item['Quantidade']
      item['valor_aduaneiro_em_modea_estrangeira'] = valor
      total += valor
    end
    dados['totais']['valor_aduaneiro_em_modea_estrangeira'] = total
  end
  def calcula_valor_aduaneiro_em_reais
    total = 0
    dados['itens'].each_with_index do |item,i|
      valor = (item['valor_aduaneiro_em_modea_estrangeira'] * dados['cambio'])
      item['valor_aduaneiro_em_reais'] = valor
      total += valor
    end
    dados['totais']['valor_aduaneiro_em_reais'] = total
  end

  def calcula_despesas_aduaneiras
    
    total_despesas_aduaneiras = dados['frete']
    total_valor_aduaneiro_em_reais = dados['totais']['valor_aduaneiro_em_reais']
    
    dados['itens'].each_with_index do |item,i|
      valor = (item['valor_aduaneiro_em_reais'] * total_despesas_aduaneiras) / total_valor_aduaneiro_em_reais
      item['despesas_aduaneiras'] = valor
    end

    dados['totais']['despesas_aduaneiras'] = total_despesas_aduaneiras

  end

  def calcula_BC_II
    dados['itens'].each_with_index do |item,i|
      valor = item['despesas_aduaneiras']+item['valor_aduaneiro_em_reais']
      item['BC_II'] = valor
    end
  end

  def calcula_valor_II
    total = 0
    dados['itens'].each_with_index do |item,i|
      valor = item['BC_II'] * item['II']
      
      item['valor_II'] = valor
      total += valor
    end
    dados['totais']['valor_II'] = total
  end

  def calcula_BC_IPI
    dados['itens'].each do |item|
      valor = item['BC_II'] + item['valor_II']
      
      item['BC_IPI'] = valor
    end
  end

  def calcula_valor_IPI
    total = 0
    dados['itens'].each do |item|
      valor = item['BC_IPI'] * item['IPI']
      
      item['valor_IPI'] = valor
      total += valor
    end
    dados['totais']['valor_IPI'] = total
  end

  def calcula_BC_PIS_COFINS
    total = 0
    dados['itens'].each do |item|
      valor = item['BC_II']
      
      item['BC_PIS_COFINS'] = valor
      total += valor
    end
    dados['totais']['BC_PIS_COFINS'] = total
  end

  def calcula_valor_PIS
    total = 0
    dados['itens'].each do |item|
      valor = item['BC_II']*item['PIS']
      
      item['valor_PIS'] = valor
      total += valor
    end
    dados['totais']['valor_PIS'] = total
  end

  def calcula_COFINS
    total = 0
    dados['itens'].each do |item|
      valor = item['BC_II']*item['COFINS']      
      item['valor_COFINS'] = valor
      total += valor
    end
    dados['totais']['valor_COFINS'] = total
  end

  def calcula_valor_total_produto
    total = 0
    dados['itens'].each do |item|
      valor = item['valor_aduaneiro_em_reais']
      item['valor_total_produto'] = valor
      total += valor
    end
    dados['totais']['valor_total_produto'] = total
  end

  def calcula_valor_unitario_real
    total = 0
    dados['itens'].each do |item|
      valor = item['valor_total_produto']/item['Quantidade']
      item['valor_unitario_real'] = valor
      total += valor
    end
    dados['totais']['valor_unitario_real'] = total    
  end

  def calcula_rateio_despesas_acessorias
    key = 'rateio_despesas_acessorias'
    total = 0
    dados['itens'].each do |item|
      valor = item['valor_total_produto']/dados['totais']['valor_total_produto']
      item[key] = valor
      total += valor
    end
    dados['totais'][key] = total
  end

  def calcula_despesas_acessorias
    key = 'despesas_acessorias'
    total = dados['taxa_siscomex']
    dados['itens'].each do |item|
      valor = total*item['rateio_despesas_acessorias']
      item[key] = valor
    end
    dados['totais'][key] = total
  end

  def calcula_valor_ICMS
    key = 'valor_ICMS'
    total = 0
    dados['itens'].each do |item|
      valor = ((item['valor_aduaneiro_em_reais']+item['despesas_aduaneiras']+item['valor_II']+item['valor_IPI']+item['valor_PIS']+item['valor_COFINS']+item['despesas_acessorias'])/(1-item['ICMS']))*item['ICMS']
      item[key] = valor
      total += valor
    end
    dados['totais'][key] = total
  end

  def calcula_BC_ICMS_FINAL
    key = 'BC_ICMS_FINAL'
    total = 0
    dados['itens'].each do |item|
      valor = ((item['valor_total_produto']+item['despesas_acessorias']+item['valor_COFINS']+item['valor_PIS']+item['valor_IPI']+item['valor_II']+item['despesas_aduaneiras'])/(1-item['ICMS']))
      item[key] = valor
      total += valor
    end
    dados['totais'][key] = total
  end

  def calcula_total_despesas_acessorias
    key = 'total_despesas_acessorias'
    total = 0
    dados['itens'].each do |item|
      valor = item['despesas_aduaneiras']+item['valor_PIS']+item['valor_COFINS']+item['valor_ICMS']+item['despesas_acessorias']
      item[key] = valor
      total += valor
    end
    dados['totais'][key] = total
  end

  def calcula_total_despesas_sem_frete
    key = 'total_despesas_sem_frete'
    total = 0
    dados['itens'].each do |item|
      valor = item['total_despesas_acessorias']-item['despesas_aduaneiras']
      item[key] = valor
      total += valor
    end
    dados['totais'][key] = total
  end

  def calcula_total_frete
    key = 'total_frete'
    total = 0
    dados['itens'].each do |item|
      valor = item['total_despesas_acessorias']-item['total_despesas_sem_frete']
      item[key] = valor
      total += valor
    end
    dados['totais'][key] = total
  end

  def calcula_ICMS_final
    key = 'ICMS_final'
    total = 0
    dados['itens'].each do |item|
      valor = item['BC_ICMS_FINAL']*item['ICMS']
      item[key] = valor
      total += valor
    end
    dados['totais'][key] = total
  end

  def calcula_total_nf
    key = 'total_nf'
    t = dados['totais']
    total = t['valor_aduaneiro_em_reais']+t['valor_IPI']+t['total_despesas_acessorias']+t['valor_II']
    
    dados['totais'][key] = total
  end

end
