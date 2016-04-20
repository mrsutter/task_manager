describe Web::Admin::UsersController, type: :controller do
  describe '#index' do
    context 'when user is signed in' do
      include_context 'sign in user'

      it 'redirects to new user session page' do
        get :index
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when user is guest' do
      it 'redirects to new user session page' do
        get :index
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      it 'returns success' do
        get :index
        expect(response).to be_ok
      end
    end
  end

  describe '#show' do
    let!(:tm_user) { create(:user) }

    context 'when user is signed in' do
      include_context 'sign in user'

      it 'redirects to new user session page' do
        get :show, id: tm_user.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when user is guest' do
      it 'redirects to new user session page' do
        get :show, id: tm_user.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      it 'returns success' do
        get :show, id: tm_user.id
        expect(response).to be_ok
      end
    end
  end

  describe '#new' do
    let!(:tm_user) { create(:user) }

    context 'redirects to new user session page' do
      include_context 'sign in user'

      it 'redirects to user tasks page' do
        get :new, id: tm_user.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when user is guest' do
      it 'redirects to new user session page' do
        get :new, id: tm_user.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      it 'returns success' do
        get :new, id: tm_user.id
        expect(response).to be_ok
      end
    end
  end

  describe '#create' do
    include_context 'sign in admin'

    let(:email) { 'test@google.com' }
    let(:pass) { 'password' }

    def user_params(email, pass, pass_confirmation, role = 'user')
      {
        user: {
          email: email,
          password: pass,
          password_confirmation: pass_confirmation,
          role: role
        }
      }
    end

    context 'when params are correct' do
      it 'creates new user' do
        expect { post :create, user_params(email, pass, pass) }
          .to change { User.count }.by(1)

        expect(response).to redirect_to(admin_user_url(assigns(:user)))

        user = User.find_by(email: email)
        expect(user.email).to eq(email)
        expect(user.role).to eq('user')
      end

      it 'creates new admin' do
        expect { post :create, user_params(email, pass, pass, 'admin') }
          .to change { User.count }.by(1)

        expect(response).to redirect_to(admin_user_url(assigns(:user)))

        user = User.find_by(email: email)
        expect(user.email).to eq(email)
        expect(user.role).to eq('admin')
      end
    end

    context 'when params are wrong' do
      context 'when password is too short' do
        let(:pass) { 'short' }

        it "doesn't create user" do
          expect { post :create, user_params(email, pass, pass) }
            .not_to change { User.count }

          expect(response).to be_ok
        end
      end

      context 'when passwords are not equal' do
        let(:pass_confirmation) { 'password1' }

        it "doesn't create user" do
          expect { post :create, user_params(email, pass, pass_confirmation) }
            .not_to change { User.count }

          expect(response).to be_ok
        end
      end

      context 'when password is blank' do
        let(:pass_confirmation) { 'password' }

        it "doesn't create user" do
          expect { post :create, user_params(email, '', pass_confirmation) }
            .not_to change { User.count }

          expect(response).to be_ok
        end
      end

      context 'when password confirmation is blank' do
        it "doesn't create user" do
          expect { post :create, user_params(email, pass, '') }
            .not_to change { User.count }

          expect(response).to be_ok
        end
      end

      context 'when email is incorrect' do
        it "doesn't create user" do
          expect { post :create, user_params('email', pass, pass) }
            .not_to change { User.count }

          expect(response).to be_ok
        end
      end

      context 'when email is incorrect' do
        it "doesn't create user" do
          expect { post :create, user_params('email', pass, pass) }
            .not_to change { User.count }

          expect(response).to be_ok
        end
      end

      context 'when email is blank' do
        it "doesn't create user" do
          expect { post :create, user_params('', pass, pass) }
            .not_to change { User.count }

          expect(response).to be_ok
        end
      end

      context 'when email is not unique' do
        it "doesn't create user" do
          expect { post :create, user_params(admin.email, pass, pass) }
            .not_to change { User.count }

          expect(response).to be_ok
        end
      end
    end
  end

  describe '#edit' do
    let!(:tm_user) { create(:user) }

    context 'when user is signed in' do
      include_context 'sign in user'

      it 'redirects to new user session page' do
        get :edit, id: tm_user.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when user is guest' do
      it 'redirects to new user session page' do
        get :edit, id: tm_user.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      it 'returns success' do
        get :edit, id: tm_user.id
        expect(response).to be_ok
      end

      context 'when trying to edit himself' do
        it 'redirects to admin users page when admin try edit himself' do
          get :edit, id: admin.id
          expect(response).to redirect_to(admin_users_url)
        end
      end
    end
  end

  describe '#update' do
    include_context 'sign in admin'

    let!(:tm_user) { create(:user) }

    it 'changes user role' do
      user_params = { role: 'admin' }
      expect { patch :update, id: tm_user.id, user: user_params }
        .to change { tm_user.reload.role }.from('user').to('admin')
      expect(response).to redirect_to(admin_user_url(assigns(:user)))
    end
  end

  describe '#destroy' do
    include_context 'sign in admin'

    let!(:tm_user) { create(:user) }

    it 'changes user role' do
      expect { delete :destroy, id: tm_user.id }
        .to change { User.count }.by(-1)

      user = User.find_by(email: tm_user.email)
      expect(user).to be nil

      expect(response).to redirect_to(admin_users_url)
    end
  end
end
