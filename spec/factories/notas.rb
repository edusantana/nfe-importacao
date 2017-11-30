FactoryBot.define do
  factory :nota do
    user
    #planilha_itens

    trait :com_planilhas do
      planilha_itens {arquivo('joao/planilha_itend.ods')}
      cambio {3.0 + rand}
    end
  end
end
