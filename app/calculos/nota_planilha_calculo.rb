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
    ler_itens
    ler_extra
    dados['totais'] = {}
    calcula_valor_aduaneiro_em_modea_estrangeira
    calcula_valor_aduaneiro_em_reais

    dados
  end

  private

  def ler_planilha
    @planilha = Roo::Spreadsheet.open(nota.planilha_itens.path) 
  end
  
  def ler_itens
    itens = []

    sheet = @planilha.sheet('Itens')

    sheet.each(item: 'Item', :headers => true) do |hash|
      itens << hash
    end

    itens.delete_at(0)
    dados['itens'] = itens
  end

  def ler_extra
    sheet = @planilha.sheet('Extra')
    extra = {}
    cabecalhos = {'Câmbio' => 'cambio'}
    sheet.each do |linha|
      key = cabecalhos[linha[0]]
      extra[key] = linha[1]
    end
    dados.merge!(extra)
  end

  def calcula_valor_aduaneiro_em_modea_estrangeira
    dados['valor_aduaneiro_em_modea_estrangeira'] = []
    total = 0
    dados['itens'].each_with_index do |item,i|
      valor = item['Preço'] * item['Quantidade']
      dados['valor_aduaneiro_em_modea_estrangeira'][i] = valor
      total += valor
    end
    dados['totais']['valor_aduaneiro_em_modea_estrangeira'] = total
  end
  def calcula_valor_aduaneiro_em_reais
    dados['valor_aduaneiro_em_reais'] = []
    total = 0
    dados['valor_aduaneiro_em_modea_estrangeira'].each_with_index do |item,i|
      valor = (item * dados['cambio'])
      dados['valor_aduaneiro_em_reais'] << valor
      total += valor
    end
    dados['totais']['valor_aduaneiro_em_reais'] = total
  end

end
