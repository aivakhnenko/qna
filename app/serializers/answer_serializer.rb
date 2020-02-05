class AnswerSerializer < AnswersSerializer
  has_many :comments
  has_many :files, serializer: AttachmentSerializer
  has_many :links
end
