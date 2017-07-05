class AddOwnerToNode < ActiveRecord::Migration[5.0]
  def change
    add_reference :nodes, :owner, references: :users, index: true
  end
end
