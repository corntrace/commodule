ActiveRecord::Schema.define(:version => 0) do
  create_table :orders, :force => true do |t|
    t.column :title, :string
    t.column :price_in_cent, :integer
  end
  create_table :order_items, :force => true do |t|
    t.column :title, :string
    t.column :quantity, :integer
    t.column :order_id, :integer
  end
end
