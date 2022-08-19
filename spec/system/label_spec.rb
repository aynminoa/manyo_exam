require 'rails_helper'
RSpec.describe 'ラベル付与機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:label) { FactoryBot.create(:label) }
  let!(:task) { FactoryBot.create(:task, user: user)}
  let!(:labeling) {FactoryBot.create(:labeling, task: task, label: label)}

  describe 'ラベル付与機能' do
    context 'タスク新規作成した場合' do
      before do
        visit new_session_path
          fill_in 'session_email', with: 'general@example.com'
          fill_in 'session_password', with: 'testpassword'
          click_button 'ログイン'
      end
      it 'ラベルを複数つけられる' do
        second_label = FactoryBot.create(:second_label)
        FactoryBot.create(:labeling, task: task, label: second_label)
        third_label = FactoryBot.create(:third_label)
        FactoryBot.create(:labeling, task: task, label: third_label)
        visit new_task_path
        fill_in 'task_title', with: 'ライフに行く'
        fill_in 'task_content', with: 'キムチを買う'
        check 'test_label_1'
        check 'test_label_2'
        click_button '登録'
        expect(page).to have_content 'test_label_1'
        expect(page).to have_content 'test_label_2'
        expect(page).not_to have_content 'test_label_3'
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
    context '任意のラベルで検索をした場合' do
      it 'そのラベルが紐づいたタスクが絞り込まれる' do
        second_task = FactoryBot.create(:second_task, user: user )
        second_label = FactoryBot.create(:second_label)
        FactoryBot.create(:labeling, task: second_task, label: second_label)
        third_task = FactoryBot.create(:third_task, user: user )
        FactoryBot.create(:labeling, task: third_task, label: second_label)
        visit tasks_path
        task_list = all('.task_row')
        expect(task_list.count).to eq 3
        select 'test_label_2', from: 'task[label_id]'
        click_on '検索'
        expect(all('tbody tr')[1]).to have_content 'test_label_2'
        expect(all('tbody tr')[2]).to have_content 'test_label_2'
        task_list = all('.task_row')
        expect(task_list.count).to eq 2
      end
    end
  end
end

