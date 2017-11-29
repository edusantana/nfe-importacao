class CreateNotas < ActiveRecord::Migration[5.1]
  def change
    create_table :notas do |t|
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
