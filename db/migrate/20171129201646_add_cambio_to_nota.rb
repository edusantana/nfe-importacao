class AddCambioToNota < ActiveRecord::Migration[5.1]
  def change
    add_column :notas, :cambio, :float
  end
end
