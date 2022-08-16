class User < ApplicationRecord
before_destroy :must_not_destroy_last_admin
before_update :must_not_update_last_admin 

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_many :tasks, dependent: :destroy
  has_secure_password
  validates :password, length: { minimum: 6 }

  private

  def must_not_destroy_last_admin
    if User.where(admin: :true).count == 1 && self.admin == true
      throw :abort
    end
  end

  def must_not_update_last_admin
    if User.where(admin: :true).count == 1 && self.admin_change == [true,false]
      errors.add :base, '管理者は少なくとも1人必要です'
      throw :abort      
    end
  end

end
