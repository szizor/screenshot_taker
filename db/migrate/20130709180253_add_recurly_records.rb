class AddRecurlyRecords < ActiveRecord::Migration
  def self.up
    create_table(:purchases) do |t|
      t.string   "first_name",                  :default => "", :null => false
      t.string   "first_name",                  :default => "", :null => false
      t.string   "email",                  :default => "", :null => false
      t.string   "customer_id"
      t.integer  "plan_id"
      t.timestamps
    end
    add_index :purchases, [:email], :name => "index_purcharses_on_email", :unique => false
  end

  def self.down
    drop_table :delayed_jobs
  end
end
