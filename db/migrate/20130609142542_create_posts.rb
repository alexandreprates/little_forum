class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, :engine => "MyISAM" do |t|
      t.string :content
      t.boolean :topic, :default => false
      t.string :path
      t.integer :children, :default => 0
      t.timestamps
    end
    add_index :posts, :path
    add_index :posts, :topic
  end
end
