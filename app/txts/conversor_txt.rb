require "erb" # remover
require 'roo'

class ConversorTxt
  include ActionView::Helpers::NumberHelper  
  
  attr_reader :nota  
  attr_reader :dados
    
  def initialize(nota=nil)
    
    @string = nil
    @dados = nil
    @nota = nota
    
    # @d = JSON.parse(nota.dados.to_json,object_class: OpenStruct)
  end
  
  def interpreta_conteudo_txt(conteudo_txt)
    @string = StringIO.new(conteudo_txt)
    @linha_lida = []
    
    ler_cabecalho_NOTAFISCAL # ignora no momento
    @dados = ler_A
    
    @dados
  end

  def escreve_conteudo_txt
    @string = StringIO.new()
    escreve_cabecalho_NOTAFISCAL
    escreve_campos_e_grupos(@dados)
    @string.string
  end

  def converte_para_txt
    gera_conteudo_txt
    escreve_conteudo_txt
  end

  private

  # gera representação da nota em formato intermediário: @dados
  def gera_conteudo_txt
=begin
    # A - Dados da Nota Fiscal eletrônica
    # B - Identificação da Nota Fiscal eletrônica
    # C - Identificação do Emitente da Nota Fiscal eletrônica
    # D - Identificação do Fisco Emitente da NF-e
    # E - Identificação do Destinatário da Nota Fiscal eletrônica
    # F - Identificação do Local de Retirada
    # G - Identificação do Local de Entrega
    # H - Detalhamento de Produtos e Serviços da NF-e
    # I - Produtos e Serviços da NF-e
    J - Detalhamento Específico de Veículos novos
    K - Detalhamento Específico de Medicamento e de matérias-primas farmacêuticas
    L - Detalhamento Específico de Armamentos
    L1 - Detalhamento Específico de Combustíveis
    M - Tributos incidentes no Produto ou Serviço
    N - ICMS Normal e ST
    O - Imposto sobre Produtos Industrializados
    P - Imposto de Importação
    Q – PIS
    R – PIS ST
    S – COFINS
    T - COFINS ST
    U - ISSQN
    V - Informações adicionais
    W - Valores Totais da NF-e
    X - Informações do Transporte da NF-e
    Y – Dados da Cobrança
    Z - Informações Adicionais da NF-e
    ZA - Informações de Comércio Exterior
    ZB - Informações de Compras
    ZC - Informações do Registro de Aquisição de Cana
    ZZ - Informações da Assinatura Digital

=end
    chave_vazia = '' # importando como rascunho nao tem chave
    @dados = {key: 'A', campos:['3.10',chave_vazia], grupos:[grupo_B, grupo_C, grupo_E, grupo_H, grupo_W, grupo_X, grupo_Z].flatten.compact}
  end

  def grupo_B
    campos = 'cUF|cNF|natOp|indPag|mod|serie|nNF|dhEmi|dhSaiEnt|tpNF|idDest|cMunFG|tpImp|tpEmis|cDV|tpAmb|finNFe|indFinal|indPres|procEmi|verProc|dhCont|xJust'
    {key: 'B', campos: ler_campos_da_nota('B', campos, @nota.dados), grupos:[]}
  end

  def ler_campos_da_nota(chave, campos, hash)
    valores = []
    origem = hash[chave]
    campos.split('|').each do |campo| 
      valores << origem[campo] || ''
    end
    valores
  end

  def grupo_C
    campos = 'xNome|xFant|IE|IEST|IM|CNAE|CRT'
    {key: 'C', campos: ler_campos_da_nota('C', campos, @nota.dados), grupos:[grupo_C02, grupo_C05].flatten.compact}
  end

  def grupo_C02
    campos = 'CNPJ'
    {key: 'C02', campos: ler_campos_da_nota('C', campos, @nota.dados), grupos:[]}
  end

  def grupo_C05
    campos = 'xLgr|nro|xCPL|xBairro|cMun|xMun|UF|CEP|cPais|xPais|fone'
    {key: 'C05', campos: ler_campos_da_nota('C', campos, @nota.dados), grupos:[]}
  end

  def grupo_E
    campos = 'xNome|indIEDest|IE|ISUF|IM|email'
    {key: 'E', campos: ler_campos_da_nota('E', campos, @nota.dados), grupos:[grupo_E05].flatten.compact}
  end

  def grupo_E05
    campos = 'xLgr|nro|xCpl|xBairro|cMun|xMun|UF|CEP|cPais|xPais|fone'
    {key: 'E05', campos: ler_campos_da_nota('E', campos, @nota.dados), grupos:[].flatten.compact}
  end

  def grupo_H
    result = []
    @nota.dados['itens'].each_with_index do |item, n|
      result << {key: 'H', campos: [n+1,'.'], grupos:[grupo_I(item, n), grupo_M(item, n)].flatten.compact}
    end
    result
  end

  def grupo_I(item, n)
    result = []
    
    c = ['0000',''] # "cProd"=>"0000", "cEAN"=>"",

    # {"Item"=>"item1", "Preço"=>5, "Quantidade"=>5, "II"=>0.18, "IPI"=>0.05, "PIS"=>0.021, "COFINS"=>0.1065, "ICMS"=>0.18, "valor_aduaneiro_em_modea_estrangeira"=>25, "valor_aduaneiro_em_reais"=>79.185, "despesas_aduaneiras"=>58.748591549295796, "BC_II"=>137.93359154929578, "valor_II"=>24.82804647887324, "BC_IPI"=>162.76163802816902, "valor_IPI"=>8.138081901408452, "BC_PIS_COFINS"=>137.93359154929578, "valor_PIS"=>2.896605422535212, "valor_COFINS"=>14.689927500000001, "valor_total_produto"=>79.185, "valor_unitario_real"=>15.837, "rateio_despesas_acessorias"=>0.03521126760563381, "despesas_acessorias"=>7.552816901408453, "valor_ICMS"=>43.032966531260726, "BC_ICMS_FINAL"=>239.07203628478192, "total_despesas_acessorias"=>126.92090790450018, "total_despesas_sem_frete"=>68.17231635520439, "total_frete"=>58.748591549295796, "ICMS_final"=>43.03296653126074}
    # cProd|cEAN|xProd|NCM|EXTIPI|CFOP|uCom|qCom|vUnCom|vProd|cEANTrib|uTrib|qTrib|vUnTrib|vFrete|vSeg|vDesc|vOutro|indTot|xPed|nItemPed|nFCI
    
    # {"cProd"=>"0000", "cEAN"=>"", "xProd"=>"OBL-12-01-01 - ACABAMENTO AUTOMOTIVO DA GRADE DIANTEIRA, LADO ESQUERDO E DIREITO EM PLASTICO ABS CROMADO COMPATIVEL C...", "NCM"=>"87082999", "EXTIPI"=>"", "CFOP"=>"3102", "uCom"=>"PAR", "qCom"=>"5.0000", "vUnCom"=>"15.8370000000", "vProd"=>"79.19", "cEANTrib"=>"", "uTrib"=>"PAR", "qTrib"=>"5.0000", "vUnTrib"=>"15.8370000000", "vFrete"=>"58.75", "vSeg"=>"", "vDesc"=>"", "vOutro"=>"68.17", "indTot"=>"1", "xPed"=>nil, "nItemPed"=>nil, "nFCI"=>nil} 
    # TXT:
    # I|0000||OBL-12-01-01 - ACABAMENTO AUTOMOTIVO DA GRADE DIANTEIRA, LADO ESQUERDO E DIREITO EM PLASTICO ABS CROMADO COMPATIVEL C...|87082999||3102|PAR|5.0000|15.8370000000|79.19||PAR|5.0000|15.8370000000|58.75|||68.17|1||||

    c << item['Item'].truncate(120) 

    # cProd|cEAN|xProd| **NCM** |EXTIPI|CFOP|uCom|qCom|vUnCom|vProd|cEANTrib|uTrib|qTrib|vUnTrib|vFrete|vSeg|vDesc|vOutro|indTot|xPed|nItemPed|nFCI
    c << nota.dados['NCM']
    
    # EXTIPI|CFOP|uCom|qCom|vUnCom|vProd|cEANTrib|uTrib|qTrib|vUnTrib|vFrete|vSeg|vDesc|vOutro|indTot|xPed|nItemPed|nFCI
    # "EXTIPI"=>""

    c << item['EXTIPI']

    #  "CFOP"=>"3102", 
    c << item['CFOP']

    # "uCom"=>"PAR", 
    c << item['uCom'].truncate(6, omission: '')

    # "qCom"=>"5.0000", 
    c << "%0.4f" % item['Quantidade'].to_f
    
    # "vUnCom"=>"15.8370000000", 
    c << "%0.10f" % item['valor_unitario_real'].to_f
    
    # "vProd"=>"79.19", 
    c << "%0.2f" % item['valor_total_produto'].to_f

    # "cEANTrib"=>"", 
    c << item['cEANTrib']
    
    # "uTrib"=>"PAR", 
    c << (item['uTrib'] or item['uCom']).truncate(6, omission: '')
    
    # "qTrib"=>"5.0000", 

    c << "%0.4f" % item['Quantidade'].to_f

    # "vUnTrib"=>"15.8370000000", 
    c << "%0.10f" % item['valor_unitario_real'].to_f
    
    # "vFrete"=>"58.75", 
    c << "%0.2f" % item['total_frete']
    
    # "vSeg"=>"", 
    c << item['vSeg']
    
    # "vDesc"=>"", 
    c << item['vDesc']
    
    # "vOutro"=>"68.17", 
    c << item['total_despesas_sem_frete'].round(2)
    
    # "indTot"=>"1", 
    c << item['indTot'] # == '' ? @nota.dados['itens'].first('indTot') : item['indTot']
    #byebug
    
    # "xPed"=>nil, "nItemPed"=>nil, "nFCI"=>nil
    c << item['xPed']
    c << item['nItemPed']
    c << item['nFCI']
    

    result << {key: 'I', campos: c, grupos:[grupo_I05a(item), grupo_I05c(item), grupo_I18].flatten.compact}
    

    result
  end

  def grupo_I05a(item)
    result = []
    nves = (item['NVE'] or "").split ','
    result += nves.map {|nve| {key: 'I05a', campos: nve, grupos:[]} }

    result
  end

  def grupo_I05c(item)
    #[0 ou 1]{
    #I05c|CEST


    cest = item['CEST']
    if cest.nil? || cest == ''
      return []
    else
      return {key: 'I05c', campos: [cest], grupos:[]}
    end

  end

  def grupo_I18
    #[0 a 100]{
    # I18|nDI|dDI|xLocDesemb|UFDesemb|dDesemb|tpViaTransp|vAFRMM|tpIntermedio|CNPJ|UFTerceiro|cExportador|
    #     [1 a 100]{
    #     I25|nAdicao|nSeqAdicC|cFabricante|vDescDI|nDraw|
    unless nota.dados['importacao']
      []
    else
      c = ("nDI|dDI|xLocDesemb|UFDesemb|dDesemb|tpViaTransp|vAFRMM|tpIntermedio|CNPJ|UFTerceiro|cExportador".split '|').map {|k| nota.dados['importacao'][k]}
      return {key: 'I18', campos: c, grupos:[grupo_I25].flatten.compact}
    end
  end

  def grupo_I25
    c = 'nAdicao|nSeqAdicC|cFabricante|vDescDI|nDraw'.split('|').map{|k| nota.dados['importacao'][k] }
    return {key: 'I25', campos: c, grupos:[].flatten.compact}
  end

  def grupo_M(item, n)
    # M|vTotTrib|
    {key: 'M', campos: [''], grupos:[grupo_N(item,n), grupo_O(item), grupo_P(item), grupo_Q(item), grupo_S(item)].flatten.compact}
  end

  def grupo_N(item, n)
    {key: 'N', campos: [], grupos:[grupo_Ni(item,n)].flatten.compact}
  end

  def grupo_Ni(item,n)
    # assume: Tributação do ICMS - 90 – Outros
      #byebug
      #
    case item['CSOSN']
    when 102, 103, 300, 400
      # N10d
      # Grupo CRT=1 – Simples Nacional e CSOSN=102, 103, 300 ou 400
      # Tributação do ICMS pelo SIMPLES NACIONAL e CSOSN=102, 103, 300 ou 400 (v.2.0)
        key = 'N10d'
        h = {orig: item['orig'], CSOSN: item['CSOSN']}        
    when 900
      # N10h
      # orig|CSOSN|modBC|vBC|pRedBC|pICMS|vICMS|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|pCredSN|vCredICMSSN
      key = 'N10h'
      h = {orig: item['orig'], CSOSN: item['CSOSN'], modBC: item['modBC'], vBC: '%0.2f' % item['BC_ICMS_FINAL'], pRedBC: '', 
          pICMS: "%0.2f" % (item['ICMS']*100), vICMS: '%0.2f' % item['ICMS_final'], modBCST: '', pMVAST: '', pRedBCST: '', vBCST: '', pICMSST: '', vICMSST: '', pCredSN: '', vCredICMSSN: ''}
    end

    {key: key, campos: h.values, grupos:[].flatten.compact}
  end

  def grupo_O(item)
    # [0 ou 1]{
    # O|clEnq|CNPJProd|cSelo|qSelo|cEnq|
    # O|||||999|
    {key: 'O', campos: ['','','','','999'], grupos:[grupo_O07(item), grupo_O10(item)].flatten.compact}
  end

  def grupo_O07(item)
    # O07|CST|vIPI|
    {key: 'O07', campos: [49, "%0.2f" % item['valor_IPI']], grupos:[].flatten.compact}
  end

  def grupo_O10(item)
    # O10|vBC|pIPI|
    # O10|162.76|5.0000|
    {key: 'O10', campos: ["%0.2f" % item['BC_IPI'], "%0.4f" % (item['IPI']*100)], grupos:[].flatten.compact}
  end

  def grupo_P(item)
    # P|137.93|126.92|24.83|0.00|
    # P|vBC|vDespAdu|vII|vIOF|
    c = [item['BC_PIS_COFINS'], item['total_despesas_acessorias'], item['valor_II'], 0].map {|v| "%0.2f" % v}
    {key: 'P', campos: [c], grupos:[].flatten.compact}
  end

  def grupo_Q(item)
=begin
    Q|
      [Seleção entre Q02 ou Q03 ou Q04 ou Q05]{
        Q02|CST|vBC|pPIS|vPIS|
        [ou]
        Q03|CST|qBCProd|vAliqProd|vPIS|
        [ou]
        Q04|CST|
        [ou]
        Q05|CST|
        [Seleção entre Q07 ou Q010]{
          Q07|vBC|pPIS|vPIS|
          [ou]
          Q10|qBCProd|vAliqProd|
        }
      }
    }
=end
    q07 = {key: 'Q07', campos: ["%0.2f" % item['BC_II'], "%0.4f" % (item['PIS']*100)], grupos:[].flatten.compact}
    q05 = {key: 'Q05', campos: [98,"%0.2f" % item['valor_PIS']], grupos:[q07].flatten.compact} # no txt há dois campos!?
    {key: 'Q', campos: [], grupos:[q05].flatten.compact}
  end

  def grupo_S(item)
=begin
  S|
    [Seleção entre S02 ou S03 ou S04 ou S05]{
    S02|CST|vBC|pCOFINS|vCOFINS|
    [ou]
    S03|CST|qBCProd|vAliqProd|vCOFINS|
    [ou]
    S04|CST|
    [ou]
    S05|CST|vCOFINS|
    [Seleção entre S07 ou S09]{
      S07|vBC|pCOFINS|
      [ou]
      S09|qBCProd|vAliqProd|
      }
    }
  }
=end
    {key: 'S', campos: [], grupos:[grupo_S05(item)].flatten.compact}
  end

  def grupo_S05(item)
    {key: 'S05', campos: [98, '%0.2f' % item['valor_COFINS']], grupos:[grupo_S07(item)].flatten.compact}
  end

  def grupo_S07(item)
    c = ["%0.2f" % item['BC_PIS_COFINS'], "%0.4f" % (item['COFINS']*100)]
    {key: 'S07', campos: [c], grupos:[].flatten.compact}
  end

  def grupo_W
    {key: 'W', campos: [], grupos:[grupo_W02].flatten.compact}
  end

  def grupo_W02
    # vBC|vICMS|vICMSDeson|vBCST|vST|vProd|vFrete|vSeg|vDesc|vII|vIPI|vPIS|vCOFINS|vOutro|vNF|vTotTrib|
    # -W02|6789.66|1222.13|0.00|0.00|0.00|2248.88|1668.43|0.00|0.00|705.13|231.13|82.24|417.16|1936.10|6789.67|0.00|

    c = []
    #c = ('6789.66|1222.13|0.00|0.00|0.00|2248.88|1668.43|0.00|0.00|705.13|231.13|82.24|417.16|1936.10|6789.67|0.00'.split '|').map {|v| v.to_f}
    #vBC
    c << nota.dados['totais']['BC_ICMS_FINAL']
    #vICMS
    c << nota.dados['totais']['valor_ICMS']
    #vICMSDeson
    c << 0
    #vBCST
    c << 0
    #vST
    c << 0
    #vProd
    c << nota.dados['totais']['valor_total_produto']
    #vFrete
    c << nota.dados['totais']['total_frete']
    #vSeg
    c << 0
    #vDesc
    c << 0
    #vII
    c << nota.dados['totais']['valor_II']
    #vIPI
    c << nota.dados['totais']['valor_IPI']
    #vPIS
    c << nota.dados['totais']['valor_PIS']
    #vCOFINS
    c << nota.dados['totais']['valor_COFINS']
    #vOutro
    c << nota.dados['totais']['total_despesas_sem_frete']
    #vNF
    c << nota.dados['totais']['total_nf']
    #vTotTrib
    c << 0

    {key: 'W02', campos: c.map {|v| '%0.2f' % v}, grupos:[grupo_W04].flatten.compact}
  end

  def grupo_W04
=begin
    -W04c|0.00|
    -W04e|0.00|
    -W04g|0.00|
=end
    result = []

    result << {key: 'W04c', campos: ['0.00'], grupos:[].flatten.compact}
    result << {key: 'W04e', campos: ['0.00'], grupos:[].flatten.compact}
    result << {key: 'W04g', campos: ['0.00'], grupos:[].flatten.compact}

    result
  end

  def grupo_X
    # X|modFrete|
    c = [nota.dados['transporte']['modFrete']]
    {key: 'X', campos: c, grupos:[grupo_X26].flatten.compact}
  end

  def grupo_X26
    # X26|qVol|esp|marca|nVol|pesoL|pesoB|
    result = []

    nota.dados['transporte']['transportes'].each do |t|
      c = 'qVol|esp|marca|nVol|pesoL|pesoB'.split('|').map {|k| t[k]}
      c[4] = '%0.3f' % c[4]
      c[5] = '%0.3f' % c[5]

      result << {key: 'X26', campos: c, grupos:[].flatten.compact}
    end

    result
  end

  def grupo_Z
    # ;S/REF: FATURACOMERCIAL201713JBR N/REF: ABC55517DHL DI: 1716607959 PIS: R$ 82,26 COFINS: R$ 417,19 TUS: R$ 214,50
    infAdFisco = ''
    pis = number_to_currency(@nota.dados['totais']['valor_PIS'], precision: 2)
    cofins = number_to_currency(@nota.dados['totais']['valor_COFINS'], precision: 2)
    tus = number_to_currency(@nota.dados['totais']['despesas_acessorias'], precision: 2)
    
    infCpl= "PIS: #{pis} COFINS: #{cofins} TUS: #{tus}"
    
    
    {key: 'Z', campos: [infAdFisco, infCpl] , grupos:[].flatten.compact}
  end

  def ler_linha
    @linha_lida.empty? ? @string.gets : @linha_lida.pop
  end

  def ler_campos(tipo_esperado=nil)
    linha = ler_linha
    l = linha.strip.split('|', -1) # não remove empty string

    if (tipo_esperado.nil? || tipo_esperado == l[0])
      # OK
      l.pop # ignore ultimo valor, pois como o string sempre termina em '|', então split reconhece o último como vazio
      return {key: l.shift, campos: l}, true
    else
      # precisa devolver linha lida
      @linha_lida.push(linha)
      return nil, false
    end
  end

  


  def escreve_campos_e_grupos(hash)
    
    @string.write hash[:key]
    
    unless hash[:campos].empty?
      campos_srt = '|' + hash[:campos].join('|')
      @string.write campos_srt
    end
    
    @string.write("|\n")   

    (hash[:grupos] or []).each do |grupo|
      escreve_campos_e_grupos(grupo)
    end

  end
  
  def escreve_linha(cabeca, campos = [])
    @string.write(cabeca)

    unless campos.empty?
      campos_srt = '|' + campos.join('|')
      @string.write campos_srt
    end

    @string.write("|\n")
  end

  def linha
    l = @string.gets.strip.split('|')
    {l.shift => {campos: l}}
  end
  def ler_cabecalho_NOTAFISCAL
    linha
    # apenas ler uma linha
  end
  def escreve_cabecalho_NOTAFISCAL
    # o cabeçalho é escrito diferente, único que não termina com |
    w "NOTAFISCAL|1\n"
  end

  # escreve
  def w(str)
    @string<<str
  end

  
  def salva_grupos(h, key, grupo)
    h[key][:grupo] = grupo
  end
  
  def salva_campos(hash, linha)
    hash.merge! linha
  end

  def escreve_campos(hash, key)
    escreve_linha(key, hash[key][:campos])
  end
  
  def escreve_grupos(hash, key)
    grupos = hash[key][:grupos] or []

    grupos.each do |k, grupo|
      escreve_campos(grupo, key)
    end
    
  end

  def escreve_A
    #w "A|3.10|NFe28170914626983000180550010000073421|\n"
    escreve_campos(@dados, 'A')
    escreve_grupos(@dados, 'A')
    
  end
  
  # #A - Dados da Nota Fiscal eletrônica
  # h hash
  def ler_A
    c,ok  = ler_campos('A')
    {key: c[:key], campos: c[:campos], grupos: [ler_A_B, ler_A_C, ler_A_D, ler_A_E, ler_A_H, ler_A_W, ler_A_X, ler_A_Z].flatten.compact }
    # 
  end
  
  def ler_A_B
    c,ok  = ler_campos('B')
    result = {key: c[:key], campos: c[:campos], grupos: [] }
    result
  end

  def ler_A_C
    c,ok = ler_campos 'C'
    result = {key: c[:key], campos: c[:campos], grupos: [ler_A_C_C02_ou_C02a, ler_A_C_C05].compact } # , ler_A_C_C02a
    # 
  end

  # [seleção entre C02 ou C02a]{
  #  C02|CNPJ|
  #  [ou]
  #  C02a|CPF|
  #  }
  def ler_A_C_C02_ou_C02a
    c,ok = ler_campos
    {key: c[:key], campos: c[:campos], grupos: []}
  end

  def ler_A_C_C05
    c,ok = ler_campos 'C05'
    result = {key: c[:key], campos: c[:campos], grupos: [].flatten.compact } # , ler_A_C_C02a
  end

  def ler_A_D
    nil
  end

  def ler_A_E
    c,ok = ler_campos 'E'
    if ok
      result = {key: c[:key], campos: c[:campos], grupos: [ler_A_E_E05].flatten.compact } # , ler_A_C_C02a
    else
      result = nil
      # FIXME push valor lido
    end

    result
  end

  def ler_A_E_E05
    c,ok = ler_campos 'E05'
    result = {key: c[:key], campos: c[:campos], grupos: [] }
  end

  # [1 a 990]{
  # H|nItem|infAdProd|
  def ler_A_H
    result = []
    
    begin
      c,ok = ler_campos 'H'
      if ok
        result << {key: c[:key], campos: c[:campos], grupos: [ler_A_H_I, ler_A_H_M].flatten.compact }
      end

    end while(ok)

    result
  end

  def ler_A_H_I
    c,ok = ler_campos 'I'
    result = {key: c[:key], campos: c[:campos], grupos: [ler_A_H_I_I05c, ler_A_H_I_I18].flatten.compact }
  end

  def ler_A_H_I_I05c
    c,ok = ler_campos 'I05c'
    if ok
      result = {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
    else
      nil
    end
  end

  # [0 a 100]{
  def ler_A_H_I_I18
    result = []
    
    begin
      c,ok = ler_campos 'I18'
      if ok
        result << {key: c[:key], campos: c[:campos], grupos: [ler_A_H_I_I18_I25].flatten.compact }
      end

    end while(ok)

    result    
  end

  # [1 a 100]
  def ler_A_H_I_I18_I25
    result = []
    
    begin
      c,ok = ler_campos 'I25'
      if ok
        result << {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
      end

    end while(ok)

    result
  end

  def ler_A_H_M
    c,ok = ler_campos 'M'
    result = {key: c[:key], campos: c[:campos], grupos: [ler_A_H_M_N, ler_A_H_M_O, ler_A_H_M_P, ler_A_H_M_Q, ler_A_H_M_S].flatten.compact }
  end

  def ler_A_H_M_N
    c,ok = ler_campos 'N'
    result = {key: c[:key], campos: c[:campos], grupos: [ler_A_H_M_N_internos].flatten.compact }
  end

  def ler_A_H_M_N_internos
    c,ok = ler_campos nil
    result = {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
  end

  def ler_A_H_M_O
    result = nil
    c,ok = ler_campos 'O'
    if ok
      result = {key: c[:key], campos: c[:campos], grupos: [ler_A_H_M_O_O07].flatten.compact }
    end
    result
  end

  def ler_A_H_M_O_O07
    result = nil
    c,ok = ler_campos 'O07'
    if ok
      result = {key: c[:key], campos: c[:campos], grupos: [ler_A_H_M_O_O07_internos].flatten.compact }
    end
    result
  end

  def ler_A_H_M_O_O07_internos
    c,ok = ler_campos nil
    result = {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
  end

  def ler_A_H_M_P
    c,ok = ler_campos nil
    if ok
      result = {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
    else
      nil
    end
  end

  def ler_A_H_M_Q
    result = []
    c,ok = ler_campos 'Q'
    if ok
      result << {key: c[:key], campos: c[:campos], grupos: [ler_A_H_M_Q_internos].flatten.compact }
    end
    result
  end

  def ler_A_H_M_Q_internos
    c,ok = ler_campos nil
    if ['Q02', 'Q03', 'Q04'].include? c[:key]
      result = {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
    elsif 'Q05' == c[:key]
      result = {key: c[:key], campos: c[:campos], grupos: [ler_A_H_M_Q_Q05_internos].flatten.compact }
    else
      # inconsistente
      nil
    end
  end

  def ler_A_H_M_Q_Q05_internos
    c,ok = ler_campos nil
    result = {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
  end

  def ler_A_H_M_S
    c,ok = ler_campos 'S'
    if ok
      result = {key: c[:key], campos: c[:campos], grupos: [ler_A_H_M_S_internos].flatten.compact }
    else
      nil
    end
  end

  def ler_A_H_M_S_internos
    c,ok = ler_campos nil
    if ['S02', 'S03', 'S04'].include? c[:key]
      result = {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
    elsif 'S05' == c[:key]
      result = {key: c[:key], campos: c[:campos], grupos: [ler_A_H_M_S_S05_internos].flatten.compact }
    else
      # inconsistente
      nil
    end    
  end

  def ler_A_H_M_S_S05_internos
    c,ok = ler_campos nil
    result = {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
  end

  def ler_A_W
    c,ok = ler_campos 'W'
    result = {key: c[:key], campos: c[:campos], grupos: [ler_A_W_W02].flatten.compact }
  end

  def ler_A_W_W02
    c,ok = ler_campos 'W02'
    result = {key: c[:key], campos: c[:campos], grupos: [ler_A_W_W02_W04].flatten.compact }
  end

  def ler_A_W_W02_W04
    result = []

    ['W04c', 'W04e', 'W04g'].each do |key|
      c,ok = ler_campos key
      result << {key: c[:key], campos: c[:campos], grupos: [ler_A_W_W02_W04].flatten.compact } if ok
    end

    result
  end

  def ler_A_X
    c,ok = ler_campos 'X'
    result = {key: c[:key], campos: c[:campos], grupos: [ler_A_X_X26].flatten.compact }
  end

  def ler_A_X_X26
   
    result = []
    
    begin
      c,ok = ler_campos 'X26'
      if ok
        result << {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
      end

    end while(ok)

    result
  end

  def ler_A_Z
    c,ok = ler_campos 'Z'
    result = {key: c[:key], campos: c[:campos], grupos: [].flatten.compact }
  end

  # Documentação do erb: http://ruby-doc.org/stdlib-2.4.2/libdoc/erb/rdoc/ERB.html#method-c-new
  def convert_to_txt
    @job = ERB.new(File.read(Rails.root + "app/txts/layout_txt-nf-e_v3.10.1.txt.erb"), nil, '<>')
    result =  @job.result(binding)
  end
end
