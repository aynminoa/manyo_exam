require 'rails_helper'
RSpec.describe 'ラベル付与機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user) }
  let!(:label) { FactoryBot.create(:label) }
  let!(:labelings) {FactoryBot.create(:labeling, task: task, label: label)}

  describe '新規作成機能' do
    context 'タスク新規作成した場合' do
      before do
        visit new_session_path
          fill_in 'session_email', with: 'general@example.com'
          fill_in 'session_password', with: 'testpassword'
          click_button 'ログイン'
      end
      it 'ラベルをつけられる' do
        visit new_task_path
        fill_in 'task_title', with: 'ライフに行く'
        fill_in 'task_content', with: 'キムチを買う'
        check 'task[label_ids][]'
        click_button '登録'
        expect(page).to have_content 'test_label_1'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: 'general@example.com'
        fill_in 'session_password', with: 'testpassword'
        click_button 'ログイン'
      end
      it '紐づいているラベルが表示される' do
        click_on '詳細'
        expect(page).to have_content 'test_label_1'
      end
    end
  end
  describe '検索機能' do
    before do
      visit new_session_path
      fill_in 'session_email', with: 'general@example.com'
      fill_in 'session_password', with: 'testpassword'
      click_button 'ログイン'
    end
    context 'つけたラベルで検索をした場合' do
      it 'ラベルが紐づくタスクが絞り込まれる' do
        FactoryBot.create(:task, user: user )
        FactoryBot.create(:task, user: user)
        visit tasks_path
        task_list = all('.task_row')
        expect(task_list.count).to eq 3
        select 'test_label_1'
        click_on '検索'
        expect(page).to have_content 'test_label_1'
        task_list = all('.task_row')
        expect(task_list.count).to eq 1
      end
    end
  end
end

