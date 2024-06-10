# db/migrate/YYYYMMDDHHMMSS_drop_books_table.rb
class DropBooksTable < ActiveRecord::Migration[7.0]  # or your Rails version
  def up
    drop_table :books
  end

  def down
    create_table :books do |t|
    end
  end
end