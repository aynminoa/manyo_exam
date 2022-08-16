require 'rails_helper'
RSpec.describe 'ユーザ管理機能', type: :system do
  before do
    FactoryBot.create(:user)
    FactoryBot.create(:admin_user)
  end
  
  describe 'ユーザ登録に関するテスト' do
    context 'ユーザを新規登録する場合' do
      it '新規登録ができ、そのユーザのマイページが表示される' do
        visit new_user_path
        fill_in 'user_name', with: 'user1'
        fill_in 'user_email', with: 'user1@example.com'
        fill_in 'user_password', with: 'user1password'
        fill_in 'user_password_confirmation', with: 'user1password'
        click_on 'アカウント作成'
        expect(page).to have_content 'user1'
      end
    end

    context 'ユーザがログインせずタスク一覧画面に飛ぼうとした場合' do
      it 'ログイン画面に遷移する' do
        visit new_session_path
        click_on 'タスク一覧'
        visit new_session_path
      end
    end
  end

  describe 'セッション機能に関するテスト' do
    context 'ユーザがログインする場合' do
      it 'ログインができる' do
        visit new_session_path
        fill_in 'session_email', with: 'general@example.com'
        fill_in 'session_password', with: 'testpassword'
        click_button 'ログイン'
        expect(current_path).to eq user_path(id:1)
      end
    end
    context 'ユーザがログインした場合' do
      before do
          visit new_session_path
          fill_in 'session_email', with: 'general@example.com'
          fill_in 'session_password', with: 'testpassword'
          click_button 'ログイン'
        end
        it 'ユーザのマイページが表示される' do
          expect(page).to have_content 'test_generalのページ'
        end
        it '一般ユーザが他人の詳細画面に飛ぶとタスク一覧画面に遷移する' do
          visit user_path(id:2)
          expect(page).to have_content 'タスク一覧'
        end
        it 'ログアウトできる' do
          click_on 'ログアウト'
          expect(page).to have_content 'ログアウトしました'
        end
      end
    end

  describe '管理画面に関するテスト' do
    context '一般ユーザの場合' do
      it '管理画面にアクセスできず、タスク一覧が表示される' do
        visit new_session_path
        fill_in 'session_email', with: 'general@example.com'
        fill_in 'session_password', with: 'testpassword'
        click_button 'ログイン'
        click_on '管理画面'
        expect(page).to have_content 'タスク一覧'
      end
    end
    context '管理ユーザの場合' do
      before do
        visit new_session_path
        fill_in 'session_email', with: 'admin@example.com'
        fill_in 'session_password', with: 'adminpassword'
        click_button 'ログイン'
        click_on '管理画面'
      end
      it '管理画面にアクセスできる' do
        expect(page).to have_content '管理画面のユーザー一覧画面'
      end
      it 'ユーザの新規登録ができる' do
        click_on 'ユーザー登録'
        fill_in 'user_name', with: 'user2'
        fill_in 'user_email', with: 'user2@example.com'
        fill_in 'user_password', with: 'user2password'
        fill_in 'user_password_confirmation', with: 'user2password'
        click_on 'アカウント作成'
        expect(page).to have_content 'user2'
      end
      it '管理画面からユーザのマイページにアクセスできる' do
        click_on 'test_general'
        expect(page).to have_content 'test_generalのページ'
      end
      it 'ユーザの編集画面からユーザの編集ができる' do
        user = User.find_by(name: 'test_general')
        click_link '編集', href: edit_admin_user_path(user)
        fill_in 'user_name', with: 'test_general_edit'
        fill_in 'user_password', with: 'testpassword'
        fill_in 'user_password_confirmation', with: 'testpassword'
        click_on '更新'
        expect(page).to have_content 'test_general_edit'
      end
      it 'ユーザの削除ができる' do
        user = User.find_by(name: 'test_general')
        click_link '削除', href: admin_user_path(user)
        page.accept_confirm
        expect(page).to have_content 'ユーザーを削除しました'
      end
    end
  end
end