class CreateEvaluationRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :evaluation_requests do |t|
      t.string :name, null: false
      t.string :phone
      t.string :email
      t.string :goal, null: false
      t.string :modality, null: false
      t.date :preferred_on, null: false
      t.string :preferred_time, null: false
      t.text :message
      t.boolean :consent, null: false, default: false
      t.datetime :contacted_at

      t.timestamps
    end

    add_index :evaluation_requests, :created_at
  end
end
