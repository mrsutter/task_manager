class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :state, null: false
      t.text :description
      t.string :file
      t.references :user, index: true, null: false
      t.timestamps null: false
    end

    add_foreign_key :tasks, :users, on_delete: :cascade
  end
end
