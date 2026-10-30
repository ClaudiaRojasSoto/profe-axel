class CreateTrainingClips < ActiveRecord::Migration[7.2]
  def change
    create_table :training_clips do |t|
      t.string :title, null: false
      t.text :summary, null: false
      t.string :category, null: false
      t.string :duration_label, null: false
      t.string :external_url, null: false
      t.string :image_alt, null: false
      t.integer :position, null: false
      t.boolean :featured, null: false, default: false
      t.boolean :published, null: false, default: true

      t.timestamps
    end

    add_index :training_clips, :position
  end
end
