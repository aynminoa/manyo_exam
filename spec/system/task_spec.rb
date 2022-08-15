require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user) }
  
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      before do
        visit new_session_path
          fill_in 'session_email', with: 'general@example.com'
          fill_in 'session_password', with: 'testpassword'
          click_button 'ログイン'
      end
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'task_title', with: 'ライフに行く'
        fill_in 'task_content', with: 'キムチを買う'
        fill_in 'task_deadline', with: Date
        click_on '登録する'
        expect(page).to have_content 'ライフに行く'
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: 'general@example.com'
        fill_in 'session_password', with: 'testpassword'
        click_button 'ログイン'
      end
      it '作成済みのタスク一覧が表示される' do
        visit tasks_path
        expect(page).to have_content 'test_title'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      before do
        visit new_session_path
          fill_in 'session_email', with: 'general@example.com'
          fill_in 'session_password', with: 'testpassword'
          click_button 'ログイン'
        end
        it '新しいタスクが一番上に表示される' do
          FactoryBot.create(:task, title: 'task1', content: 'content2', user: user)
          FactoryBot.create(:task, title: 'task2', content: 'content2', user: user)
          visit tasks_path
          task_list = all('.task_row')
          expect(task_list[0]).to have_content 'task2'
          expect(task_list[1]).to have_content 'task1'
        end
    end
    context 'タスクの終了期限でソートした場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: 'general@example.com'
        fill_in 'session_password', with: 'testpassword'
        click_button 'ログイン'
      end
      it '終了期限が遠いタスクが上部に表示される' do
        FactoryBot.create(:task, title: 'task1', content: 'content1', deadline: '2022-08-18', user: user)
        FactoryBot.create(:task, title: 'task2', content: 'content2', deadline: '2022-08-20', user: user)
        visit tasks_path
        click_link '終了期限'
        sleep(2)
        task_list = all('.task_row')
        expect(task_list[0]).to have_content '2022-08-20'
        expect(task_list[1]).to have_content '2022-08-18'
      end
    end
      context 'タスクの優先順位でソートした場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: 'general@example.com'
        fill_in 'session_password', with: 'testpassword'
        click_button 'ログイン'
        end
      it '優先順位が高いタスクが上部に表示される' do
        FactoryBot.create(:task, title: 'task1', content: 'content1', priority: '低', user: user)
        FactoryBot.create(:task, title: 'task2', content: 'content2', priority: '高', user: user)
        visit tasks_path
        click_link '優先度'
        sleep(2)
        task_list = all('.task_row')
        expect(task_list[0]).to have_content '高'
        expect(task_list[1]).to have_content '低'
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
      it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:task, title: '掃除', content: '雑巾がけ', user: user)
        visit task_path(task)
        expect(page).to have_content '掃除'
      end
    end
  end
  describe '検索機能' do
    context 'タイトルであいまい検索をした場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: 'general@example.com'
        fill_in 'session_password', with: 'testpassword'
        click_button 'ログイン'
      end
      it "検索キーワードを含むタスクで絞り込まれる" do
        visit tasks_path
        fill_in 'task_title', with: 'test'
        click_on '検索'
        expect(page).to have_content 'test'
      end
    end
    context 'ステータス検索をした場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: 'general@example.com'
        fill_in 'session_password', with: 'testpassword'
        click_button 'ログイン'
      end
      it "ステータスに完全一致するタスクが絞り込まれる" do
        visit tasks_path
        select '完了', from: 'task_status'
        expect(page).to have_content '完了'
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: 'general@example.com'
        fill_in 'session_password', with: 'testpassword'
        click_button 'ログイン'
      end
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        FactoryBot.create(:task, user: user)
        visit tasks_path
        fill_in 'task_title', with: 'test'
        select '未着手', from: 'task_status'
        click_on '検索'
        expect(page).to have_content 'test'
        expect(page).to have_content '未着手'
      end
    end
  end
end
