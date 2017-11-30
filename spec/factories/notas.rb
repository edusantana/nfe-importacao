FactoryBot.define do

  sequence(:titulo) do |t|
    "Título qualquer#{t}"
  end

  factory :nota do
    user
    titulo
    #planilha_itens

    trait :com_planilhas do
      planilha_itens {arquivo('joao/planilha_itend.ods')}
      cambio {3.0 + rand}
    end
  end
end
