class AddBestToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :best, :boolean, null: false, default: false
  end
end
