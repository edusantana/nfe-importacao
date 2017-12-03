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
          indPag: '0',
          mod: '55',
          serie: '1',
          nNF: '7342',
          dhEmi: '2017-09-28T00:00:00-03:00',
          dhSaiEnt: '',
          tpNF: '0',
          idDest: '3',
          cMunFG: '2806701',
          tpImp: '1',
          tpEmis: '1',
          cDV: '',
          tpAmb: '1',
          finNFe: '1',
          indFinal: '0',
          indPres: '2',
          procEmi: '3',
          verProc: '3.20.55',
          dhCont: '',
          xJust: ''
        },
      C: {
        # C|JOAO PAULO PINHEIRO BARONTO-ME|JOAO PAULO|271341432||||1|
        # C|<%= d.C.xNome %>|<%= d.C.xFant %>|<%= d.C.IE %>|<%= d.C.IEST %>|<%= d.C.IM %>|<%= d.C.CNAE %>|<%= d.C.CRT %>|
        xNome: 'JOAO PAULO PINHEIRO BARONTO-ME',
        xFant: 'JOAO PAULO',
        IE: '271341432',
        IEST: '',
        IM: '',
        CNAE: '',
        CRT: '1',
        # C02|14626983000180|
        # [seleção entre C02 ou C02a]{
        #  C02|CNPJ|
        #  [ou]
        #  C02a|CPF|
        #  }
        CNPJ: '14626983000180',
        CPF: '',
        # C05|xLgr|nro|xCPL|xBairro|cMun|xMun|UF|CEP|cPais|xPais|fone|
        # C05|RUA AMINTAS MACHADO DE JESUS|126|SALA E|ROSAELZE|||SE|49100000|1058|BRASIL|7999895550|
        xLgr: 'RUA AMINTAS MACHADO DE JESUS',
        nro: '126',
        xCPL: 'SALA E',
        xBairro: 'ROSAELZE',
        cMun: '',
        xMun: '',
        UF: 'SE',
        CEP: '49100000',
        cPais: '1058',
        xPais: 'BRASIL',
        fone: '7999895550'
      },
      E: {
        # E|xNome|indIEDest|IE|ISUF|IM|email|
        # E|WENZHOU MINGBANG AUTO ACCESSORIES CO.,LTD.|9|||||
        xNome: 'WENZHOU MINGBANG AUTO ACCESSORIES CO.,LTD.',
        indIEDest: '9',
        IE: '',
        ISUF: '',
        IM: '',
        email: '',
        # E05|xLgr|nro|xCpl|xBairro|cMun|xMun|UF|CEP|cPais|xPais|fone|
        # E05|YUEXIU DISTRICT YONGFU ROAD|45|YONGFU INTERNATIONAL|...|9999999|Exterior|EX|00000000|1600|CHINA, REPUBLICA POPULAR||
        xLgr: 'YUEXIU DISTRICT YONGFU ROAD',
        nro: '45',
        xCpl: 'YONGFU INTERNATIONAL',
        xBairro: '...',
        cMun: '9999999',
        xMun: 'Exterior',
        UF: 'EX',
        CEP: '00000000',
        cPais: '1600',
        xPais: 'CHINA, REPUBLICA POPULAR',
        fone: ''
    },
    H:{
      # H|1|.|
      # H|nItem|infAdProd|
      [
        nItem: '',
        infAdProd: '',
        I: {
          #I|cProd|cEAN|xProd|NCM|EXTIPI|CFOP
          cProd: '',
          cEAN: '',
          xProd: '',
          NCM: '',
          EXTIPI: '',
          CFOP: '',
          uCom: '',
          qCom: '',
          vUnCom: '',
          vProd: '',
          cEANTrib: '',
          uTrib: '',
          qTrib: '',
          vUnTrib: '',
          vFrete: '',
          vSeg: '',
          vDesc: '',
          vOutro: '',
          indTot: '',
          xPed: '',
          nItemPed: '',
          nFCI: ''
        }
      ]
    })
    
    @d = JSON.parse(nota.dados.to_json,object_class: OpenStruct)
    

  end

  # Documentação do erb: http://ruby-doc.org/stdlib-2.4.2/libdoc/erb/rdoc/ERB.html#method-c-new
  def convert_to_txt
    @job = ERB.new(File.read(Rails.root + "app/txts/layout_txt-nf-e_v3.10.1.txt.erb"), nil, '<>')
    result =  @job.result(binding)
  end
end
