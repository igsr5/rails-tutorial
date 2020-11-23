require 'rails_helper'

describe 'ユーザー管理機能', type: :system do
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@exeample.com') }
  let!(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', admin: false, email: 'b@exeample.com') }

  before do
    # ユーザーAでログインする
    visit login_path
    fill_in 'メールアドレス', with: login_user.email
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  describe 'ユーザー一覧機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }
      it 'ユーザー一覧が表示される' do
        expect(page).to have_content 'ユーザー一覧'
      end

      it 'ユーザー一覧でユーザーAとBが表示される' do
        visit admin_users_path
        expect(page).to have_content 'ユーザーA'
        expect(page).to have_content 'ユーザーB'
      end
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b }
      it 'ユーザー一覧が表示されない' do
        expect(page).to have_no_content 'ユーザー一覧'
      end
    end
  end

  describe 'ユーザー追加機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      context '登録が成功するとき' do
        before do
          visit new_admin_user_path
          fill_in '名前', with: 'ユーザーC'
          fill_in 'メールアドレス', with: 'c@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード（確認）', with: 'password'
          click_button '登録する'
        end

        it '登録確認画面' do
          expect(page).to have_content '登録内容の確認'
          expect(page).to have_content 'ユーザーC'
          expect(page).to have_content 'c@example.com'
        end

        context '登録ボタンを押すとき' do
          before do
            click_button '登録'
          end
          it '登録が完了する' do
            expect(page).to have_selector '.alert-success', text: 'ユーザーC'
          end
        end

        context '戻るを押すとき' do
          before do
            click_button '戻る'
          end
          it 'ユーザー登録にうつる' do
            expect(page).to have_content 'ユーザー登録'
          end
        end

        context '登録が失敗するとき' do
          before do
            visit new_admin_user_path
            fill_in '名前', with: ''
            fill_in 'メールアドレス', with: ''
            fill_in 'パスワード', with: 'password'
            fill_in 'パスワード（確認）', with: 'password'
            click_button '登録する'
          end

          it do
            expect(page).to have_content 'ユーザー登録'
            expect(page).to have_content '名前を入力してください'
            expect(page).to have_content 'メールアドレスを入力してください'
          end
        end

      end
    end
  end
end
