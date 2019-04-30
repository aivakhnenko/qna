class AddAnswerRefToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :answer, foreign_key: true
  end
end
