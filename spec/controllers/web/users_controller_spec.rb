describe Web::UsersController, type: :controller do
  describe '#new' do
    context 'when user is signed in' do
      include_context 'sign in user'

      it 'redirects to user tasks page' do
        get :new
        expect(response).to redirect_to(user_tasks_url)
      end
    end

    context 'when user is guest' do
      it 'returns success' do
        get :new
        expect(response).to be_ok
      end
    end
  end

  describe '#create' do
    let(:email) { 'test@google.com' }
    let(:pass) { 'password' }

    def user_params(email, pass, pass_confirmation)
      {
        user: {
          email: email,
          password: pass,
          password_confirmation: pass_confirmation
        }
      }
    end

    context 'when params are correct' do
      it 'creates and sign in new user' do
        expect { post :create, user_params(email, pass, pass) }
          .to change { User.count }.by(1)

        expect(response).to redirect_to(user_tasks_url)

        user = User.find_by(email: email)
        expect(user.email).to eq(email)
        expect(user.role).to eq('user')

        expect(signed_in?).to eq(true)
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
        let!(:user) { create(:user) }
        it "doesn't create user" do
          expect { post :create, user_params(user.email, pass, pass) }
            .not_to change { User.count }

          expect(response).to be_ok
        end
      end
    end
  end
end
