class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.date :publication_date
      t.string :genre
      t.boolean :availability_status

      t.timestamps
    end
  end
end
