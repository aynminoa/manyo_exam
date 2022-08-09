class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  enum status: { 未着手: 0 , 着手中: 1, 完了: 2 }

  scope :search_title, -> (title){ where("title LIKE ?", "%#{title}%")}
  scope :search_status, -> (status){ where(status: status)}
  scope :title_status, -> (title, status){where("title LIKE ?","%#{title}%").where(status: status)}
end
