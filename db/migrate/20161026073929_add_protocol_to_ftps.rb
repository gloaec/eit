class AddProtocolToFtps < ActiveRecord::Migration
  def change
    add_column :ftps, :protocol, :string, null: false, default: "ftp"
  end
end
