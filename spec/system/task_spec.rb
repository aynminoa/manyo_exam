require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    FactoryBot.create(:task)
  end

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'task_title', with: 'ライフに行く'
        fill_in 'task_content', with: 'キムチを買う'
        click_on '登録する'
        expect(page).to have_content 'ライフに行く'
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        visit tasks_path
        expect(page).to have_content 'test_title'
      end
    end

    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        FactoryBot.create(:task, title: 'task1', content: 'content1')
        FactoryBot.create(:task, title: 'task2', content: 'content2')
        FactoryBot.create(:task, title: 'task3', content: 'content3')
        visit tasks_path
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'task3'
        expect(task_list[1]).to have_content 'task2'
        expect(task_list[2]).to have_content 'task1'
      end
    end
  end
  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:task, title: '掃除', content: '雑巾がけ')
        visit task_path(task)
        expect(page).to have_content '掃除'
      end
    end
  end
end
