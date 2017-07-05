class CreatePrivileges < ActiveRecord::Migration[5.0]
  def change
    create_table :privileges do |t|
      t.integer :role, null: false     # editor/spender
      t.string :name, null: false      # username or group name
      t.references :node, null: false
      t.timestamps
    end
  end
end
