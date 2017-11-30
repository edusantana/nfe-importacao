class AddTituloToNota < ActiveRecord::Migration[5.1]
  def change
    add_column :notas, :titulo, :string, null: false
  end
end
