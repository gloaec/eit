class CreateFtps < ActiveRecord::Migration
  def change
    create_table :ftps do |t|
      t.string :host
      t.integer :post
      t.string :user,               :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      t.string :root_path
      t.references :channel

      t.timestamps
    end
  end
end
