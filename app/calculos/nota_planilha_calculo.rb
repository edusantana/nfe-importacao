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
  
    
    dados
  end
  
  private
  
  def ler_planilha
    @planilha = Roo::Spreadsheet.open(nota.planilha_itens.path) 
    dados['totais'] = {}
    ler_itens
    ler_extra
    
  end
  
  def ler_itens
    itens = []

    sheet = @planilha.sheet('Itens')

    sheet.each(item: 'Item', II: 'II', :headers => true) do |hash|
      itens << hash
    end
    #byebug

    itens.delete_at(0)
    dados['itens'] = itens
  end

  def ler_extra
    sheet = @planilha.sheet('Extra')
    extra = {}
    cabecalhos = {'Câmbio' => 'cambio', 'TOTAL FRETE'=>'frete'}
    sheet.each do |linha|
      key = cabecalhos[linha[0]]
      extra[key] = linha[1]
    end
    dados.merge!(extra)
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

end
