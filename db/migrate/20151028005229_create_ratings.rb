class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|

      t.references :rateable, polymorphic: true, index: true


      t.timestamps null: false
    end
  end
end
