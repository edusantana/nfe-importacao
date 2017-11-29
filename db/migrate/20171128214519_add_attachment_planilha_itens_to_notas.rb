class AddAttachmentPlanilhaItensToNotas < ActiveRecord::Migration[5.1]
  def self.up
    change_table :notas do |t|
      t.attachment :planilha_itens
    end
  end

  def self.down
    remove_attachment :notas, :planilha_itens
  end
end
