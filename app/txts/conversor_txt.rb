require "erb"

class ConversorTxt

    attr_reader :dados
  
  def initialize()
      
    @string = nil
    @dados = nil
    
    # @d = JSON.parse(nota.dados.to_json,object_class: OpenStruct)
  end

  def interpreta_conteudo_txt(conteudo_txt)
    @string = StringIO.new(conteudo_txt)
    
    
    ler_cabecalho_NOTAFISCAL # ignora no momento
    @dados = ler_A
    
    @dados
  end

  def gera_conteudo_txt
    @string = StringIO.new()
    escreve_cabecalho_NOTAFISCAL

    byebug

    escreve_campos_e_grupos(@dados)


    @string.string
  end
  
  private

  def ler_campos
    linha_lida = @string.gets
    l = linha_lida.strip.split('|', -1) # não remove empty string
    l.pop # ignore ultimo valor, pois como o string sempre termina em '|', então split reconhece o último como vazio
    {key: l.shift, campos: l}
  end


  def escreve_campos_e_grupos(hash)
    
    @string.write hash[:key]
    
    unless hash[:campos].empty?
      campos_srt = '|' + hash[:campos].join('|')
      @string.write campos_srt
    end
    
    @string.write("|\n")
    byebug
    

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

  # #A - Dados da Nota Fiscal eletrônica
  # h hash
  def ler_A
    {key: 'A', campos: ler_campos[:campos], grupos: [ler_A_B, ler_A_C].compact }
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

  
  def ler_A_B
    byebug
    result = {key: 'B', campos: ler_campos[:campos], grupos: [] }
    result
  end

  def ler_A_C
    result = {key: 'C', campos: ler_campos[:campos], grupos: [].compact } # ler_A_C_C02, ler_A_C_C02a
  end

  # Documentação do erb: http://ruby-doc.org/stdlib-2.4.2/libdoc/erb/rdoc/ERB.html#method-c-new
  def convert_to_txt
    @job = ERB.new(File.read(Rails.root + "app/txts/layout_txt-nf-e_v3.10.1.txt.erb"), nil, '<>')
    result =  @job.result(binding)
  end
end
