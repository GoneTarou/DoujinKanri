class Work < ApplicationRecord
  belongs_to :user

  enum :work_type, {
    manga: "manga",
    novel: "novel",
    illustration: "illustration"
  }, validate: true
end
