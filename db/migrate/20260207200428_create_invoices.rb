class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.references :team, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.integer :status
      t.date :due_date
      t.datetime :paid_at

      t.timestamps
    end
  end
end
