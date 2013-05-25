class CreateRecitators < ActiveRecord::Migration
  def change
    create_table :recitators do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end
