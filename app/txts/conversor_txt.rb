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
      B: {
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
      H:[
        {
          nItem: '1',
          infAdProd: '.',
          I: {
            # I|0000||OBL-12-01-01 - ACABAMENTO AUTOMOTIVO DA GRADE DIANTEIRA, LADO ESQUERDO E DIREITO EM PLASTICO ABS CROMADO COMPATIVEL C...|87082999||3102|PAR|5.0000|15.8370000000|79.19||PAR|5.0000|15.8370000000|58.75|||68.17|1||||
            # I|cProd|cEAN|xProd|NCM|EXTIPI|CFOP|uCom|qCom|vUnCom|vProd|cEANTrib|uTrib|qTrib|vUnTrib|vFrete|vSeg|vDesc|vOutro|indTot|xPed|nItemPed|nFCI|
            cProd: '0000',
            cEAN: '',
            xProd: 'OBL-12-01-01 - ACABAMENTO AUTOMOTIVO DA GRADE DIANTEIRA, LADO ESQUERDO E DIREITO EM PLASTICO ABS CROMADO COMPATIVEL C...',
            NCM: '87082999',
            EXTIPI: '',
            CFOP: '3102',
            uCom: 'PAR',
            qCom: '5.0000',
            vUnCom: '15.8370000000',
            vProd: '79.19',
            cEANTrib: '',
            uTrib: 'PAR',
            qTrib: '5.0000',
            vUnTrib: '15.8370000000',
            vFrete: '58.75',
            vSeg: '',
            vDesc: '',
            vOutro: '68.17',
            indTot: '1',
            xPed: '',
            nItemPed: '',
            nFCI: '',
            I05a: [
              #[0 a 8]{
              #  I05a|NVE|
              #  }
              {
                NVE: ''
              }
            ],
            I05c: [
              {CEST: '0107500'}, # 0 ou 1
            ],
            I18: [ # [0 a 100]{
              {
                # I18|nDI|dDI|xLocDesemb|UFDesemb|dDesemb|tpViaTransp|vAFRMM|tpIntermedio|CNPJ|UFTerceiro|cExportador|
                nDI: '1716607959',
                dDI: '2017-09-28',
                xLocDesemb: 'AEROPORTO INTERNACIONAL DE VIRACOPOS',
                UFDesemb: 'SP',
                dDesemb: '2017-09-28',
                tpViaTransp: '4',
                vAFRMM: '',
                tpIntermedio: '1',
                CNPJ: '14626983000180',
                UFTerceiro: 'SP',
                cExportador: '1192',
                I25: [ # 0 a 500
                  {
                    # I25|1|1|1192|||
                    # I25|nAdicao|nSeqAdicC|cFabricante|vDescDI|nDraw|
                    nAdicao: '1',
                    nSeqAdicC: '1',
                    cFabricante: '1192',
                    vDescDI: '',
                    nDraw: ''
                  }
                ]
              }
            ]
          },
          M:{
            # M|vTotTrib|
            vTotTrib: '',
            N:{
              # N04|orig|CST|modBC|pRedBC|vBC|pICMS|vICMS|vICMSDeson|motDesICMS|
              # N05|orig|CST|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|vICMSDeson|motDesICMS|
              # N06|orig|CST|vICMSDeson|motDesICMS|
              # N07|orig|CST|modBC|pRedBC|vBC|pICMS|vICMSOp|pDif|vICMSDif|vICMS|
              # N08|orig|CST|vBCSTRet|vICMSSTRet|
              # N09|orig|CST|modBC|pRedBC|vBC|pICMS|vICMS|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|vICMSDeson|motDesICMS|
              # N10|orig|CST|modBC|vBC|pRedBC|pICMS|vICMS|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|vICMSDeson|motDesICMS|
              # N10a|orig|CST|modBC|vBC|pRedBC|pICMS|vICMS|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|pBCOp|UFST|
              # N10b|orig|CST|vBCSTRet|vICMSSTRet|vBCSTDest|vICMSSTDest|
              # N10c|orig|CSOSN|pCredSN|vCredICMSSN|
              # N10d|orig|CSOSN|
              # N10e|orig|CSOSN|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|pCredSN|vCredICMSSN|
              # N10f|orig|CSOSN|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|
              # N10g|orig|CSOSN|vBCSTRet|vICMSSTRet|
              N10h: {
                # N10h|orig|CSOSN|modBC|vBC|pRedBC|pICMS|vICMS|modBCST|pMVAST|pRedBCST|vBCST|pICMSST|vICMSST|pCredSN|vCredICMSSN|
                # N10h|1|900|3|239.07||18.00|43.03|||||||||
                orig: '1',
                CSOSN: '900',
                modBC: '3',
                vBC: '239.07',
                pRedBC: '',
                pICMS: '18.00',
                vICMS: '43.03',
                modBCST: '',
                pMVAST: '',
                pRedBCST: '',
                vBCST: '',
                pICMSST: '',
                vICMSST: '',
                pCredSN: '',
                vCredICMSSN: ''                
              }
            },
            O: { # [0 ou 1]
              # O|clEnq|CNPJProd|cSelo|qSelo|cEnq|
              clEnq: '',
              CNPJProd: '',
              cSelo: '',
              qSelo: '',
              cEnq: '999',
              O07: {
                # O07|CST|vIPI|
                CST: '49',
                vIPI: '8.14',
                O10: {
                  # O10|vBC|pIPI|
                  vBC: '',
                  pIPI: ''
                },
                O11: {
                  # O11|qUnid|vUnid|
                  qUnid: '',
                  vUnid: ''
                }
              }
            }
          }
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
