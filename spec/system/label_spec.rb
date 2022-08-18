require 'rails_helper'

RSpec.describe Label, type: :model do
  it "有効なtaskを生成できる" do
    expect(FactoryBot.create(:label)).to be_valid
  end
end


# ラベル付与機能
# タスクの新規作成時に複数のラベルをつけられる
# タスク詳細画面で紐づいているラベルを表示する
# つけたラベルで検索ができる

