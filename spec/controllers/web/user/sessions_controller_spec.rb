describe Web::User::SessionsController, type: :controller do
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
    let!(:user) { create(:user, email: email, password: pass) }

    def session_params(email, pass)
      {
        user_session: {
          email: email,
          password: pass
        }
      }
    end

    context 'when params are correct' do
      it 'signs in user' do
        post :create, session_params(email, pass)
        expect(response).to redirect_to(user_tasks_url)

        expect(signed_in?).to be true
      end
    end

    context 'when params are wrong' do
      context 'when password is incorrect' do
        it "doesn't sign in user" do
          post :create, session_params(email, 'not valid')

          expect(response).to redirect_to(new_user_session_url)
          expect(signed_in?).to be false
        end
      end

      context 'when password is blank' do
        it "doesn't sign in user" do
          post :create, session_params(email, '')

          expect(response).to redirect_to(new_user_session_url)
          expect(signed_in?).to be false
        end
      end

      context 'when email is blank' do
        it "doesn't sign in user" do
          post :create, session_params('', pass)

          expect(response).to redirect_to(new_user_session_url)
          expect(signed_in?).to be false
        end
      end

      context 'when email is incorrect' do
        it "doesn't sign in user" do
          post :create, session_params('test@yahoo.com', pass)

          expect(response).to redirect_to(new_user_session_url)
          expect(signed_in?).to be false
        end
      end
    end
  end

  describe '#destroy' do
    include_context 'sign in user'

    it 'signs out user and redirects to root' do
      delete :destroy
      expect(response).to redirect_to(root_url)
      expect(signed_in?).to be false
    end
  end
end
