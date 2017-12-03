require "erb"

class ConversorTxt

  attr_accessor :nota
  attr_accessor :versao
  attr_accessor :d # dados
  

  def initialize(nota)
    @nota = nota

    # converte para usar notaçao com ponto
    # ver: https://stackoverflow.com/questions/9356704/unable-to-use-dot-syntax-for-ruby-hash

    # dados
    @versao = '3.10'
    
    
    nota.dados.merge!({
      A03_id: 'NFe' + '28170914626983000180550010000073421',
      # B|cUF|cNF|natOp|indPag|mod|serie|nNF|dhEmi|dhSaiEnt|tpNF|idDest|cMunFG|tpImp|tpEmis|cDV|tpAmb|finNFe|indFinal|indPres|procEmi|verProc|dhCont|xJust|
      B:
        {
          # cUF|cNF|natOp|indPag|mod|serie|nNF|dhEmi|dhSaiEnt|tpNF|idDest|cMunFG|tpImp|tpEmis|cDV|tpAmb|finNFe|indFinal|indPres|procEmi|verProc|dhCont|xJust
          cUF: '28',
          cNF: '',
          natOp: 'COMPRA PARA COMERCIALIZACAO',
          indPag: '',
          mod: '',
          serie: '',
          nNF: '',
          dhEmi: '',
          dhSaiEnt: '',
          tpNF: '',
          idDest: '',
          cMunFG: '',
          tpImp: '',
          tpEmis: '',
          cDV: '',
          tpAmb: '',
          finNFe: '',
          indFinal: '',
          indPres: '',
          procEmi: '',
          verProc: '',
          dhCont: '',
          xJust: ''
        }
      
    })
    
    @d = JSON.parse(nota.dados.to_json,object_class: OpenStruct)
    

  end

  # Documentação do erb: http://ruby-doc.org/stdlib-2.4.2/libdoc/erb/rdoc/ERB.html#method-c-new
  def convert_to_txt
    @job = ERB.new(File.read(Rails.root + "app/txts/layout_txt-nf-e_v3.10.1.txt.erb"))
    result =  @job.result(binding)

  end
end
