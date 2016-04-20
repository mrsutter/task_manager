describe Web::User::TasksController, type: :controller do
  describe '#index' do
    context 'when user is signed in' do
      include_context 'sign in user'

      before do
        create(:task, user: user)
      end

      it 'returns success' do
        get :index
        expect(response).to be_ok
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

      before do
        create(:task, user: admin)
      end

      it 'returns success' do
        get :index
        expect(response).to be_ok
      end
    end
  end

  describe '#show' do
    let!(:another_user_task) { create(:task) }

    context 'when user is signed in' do
      include_context 'sign in user'

      let!(:task) { create(:task, user: user) }

      context 'when user views his tasks' do
        it 'returns success' do
          get :show, id: task.id
          expect(response).to be_ok
        end
      end

      context 'when user try to view another user task' do
        it 'returns not found' do
          expect { get :show, id: another_user_task.id }
            .to raise_error(ActiveRecord::RecordNotFound)
          expect(response).to be_ok
        end
      end
    end

    context 'when user is guest' do
      let!(:task) { create(:task) }

      it 'redirects to new user session page' do
        get :show, id: task.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      let!(:task) { create(:task, user: admin) }

      context 'when admin views his tasks' do
        it 'returns success' do
          get :show, id: task.id
          expect(response).to be_ok
        end
      end

      context 'when admin views another user task' do
        it 'returns not found' do
          get :show, id: another_user_task.id
          expect(response).to be_ok
        end
      end
    end
  end

  describe '#new' do
    context 'when user is signed in' do
      include_context 'sign in user'

      it 'returns success' do
        get :new
        expect(response).to be_ok
      end
    end

    context 'when user is guest' do
      it 'redirects to new user session page' do
        get :new
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      it 'returns success' do
        get :new
        expect(response).to be_ok
      end
    end
  end

  describe '#create' do
    let(:name) { 'task' }
    let(:description) { 'task_description' }

    context 'when user is signed in' do
      include_context 'sign in user'

      context 'when params are correct' do
        it 'creates new task' do
          task_params = { name: name, description: description }
          expect { post :create, task: task_params }
            .to change { user.tasks.count }.by(1)

          expect(response).to redirect_to(user_task_url(assigns(:task)))

          task = user.tasks.find_by(name: name)
          expect(task.state).to eq('new')
          expect(task.description).to eq(description)
        end
      end

      context 'when params are wrong' do
        it "doesn't create new task" do
          task_params = { name: '', description: description }
          expect { post :create, task: task_params }
            .not_to change { user.tasks.count }

          expect(response).to be_ok
        end
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      let(:user) { create(:user) }

      it 'creates new task for himself' do
        task_params = {
          name: name,
          description: description,
          user_id: admin.id
        }
        expect { post :create, task: task_params }
          .to change { admin.tasks.count }.by(1)

        expect(response).to redirect_to(user_task_url(assigns(:task)))

        task = admin.tasks.find_by(name: name)
        expect(task.state).to eq('new')
        expect(task.description).to eq(description)
      end

      it 'creates new task for another user' do
        task_params = { name: name, description: description, user_id: user.id }
        expect { post :create, task: task_params }
          .to change { user.tasks.count }.by(1)

        expect(response).to redirect_to(user_task_path(assigns(:task)))

        task = user.tasks.find_by(name: name)
        expect(task.state).to eq('new')
        expect(task.description).to eq(description)
      end
    end
  end

  describe '#edit' do
    let!(:another_user_task) { create(:task) }

    context 'when user is signed in' do
      include_context 'sign in user'

      let!(:task) { create(:task, user: user) }

      context 'when user views his tasks' do
        it 'returns success' do
          get :edit, id: task.id
          expect(response).to be_ok
        end
      end

      context 'when user try to view another user task' do
        it 'returns not found' do
          expect { get :edit, id: another_user_task.id }
            .to raise_error(ActiveRecord::RecordNotFound)
          expect(response).to be_ok
        end
      end
    end

    context 'when user is guest' do
      let!(:task) { create(:task) }

      it 'redirects to new user session page' do
        get :edit, id: task.id
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      let!(:task) { create(:task, user: admin) }

      context 'when admin views his tasks' do
        it 'returns success' do
          get :edit, id: task.id
          expect(response).to be_ok
        end
      end

      context 'when admin views another user task' do
        it 'returns not found' do
          get :edit, id: another_user_task.id
          expect(response).to be_ok
        end
      end
    end
  end

  describe '#update' do
    let(:name) { 'task' }
    let(:descr) { 'task_description' }
    let(:new_name) { 'new_task' }
    let(:new_descr) { 'new_description' }

    context 'when user is signed in' do
      include_context 'sign in user'

      let!(:task) { create(:task, name: name, description: descr, user: user) }

      context 'when params are correct' do
        it 'updates task' do
          task_params = {
            name: new_name,
            description: new_descr,
            state: 'finished'
          }
          patch :update, id: task.id, task: task_params

          expect(response).to redirect_to(user_task_url(assigns(:task)))

          task.reload

          expect(task.state).to eq('finished')
          expect(task.name).to eq(new_name)
          expect(task.description).to eq(new_descr)
        end
      end

      context 'when params are wrong' do
        it "doesn't update task" do
          task_params = {
            name: '',
            description: new_descr,
            state: 'finished'
          }
          expect { patch :update, id: task.id, task: task_params }
            .not_to change { task.reload.name }

          expect(response).to be_ok
        end
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      let(:user) { create(:user) }
      let!(:task) { create(:task) }
      let!(:task_user) { task.user }

      it 'updates task and task user' do
        task_params = {
          name: new_name,
          description: new_descr,
          state: 'started',
          user_id: user.id
        }
        expect { patch :update, id: task.id, task: task_params }
          .to change { task.reload.user }.from(task_user).to(user)

        expect(response).to redirect_to(user_task_path(assigns(:task)))

        expect(task.name).to eq(new_name)
        expect(task.state).to eq('started')
        expect(task.description).to eq(new_descr)
      end
    end
  end

  describe '#destroy' do
    let(:name) { 'task' }

    context 'when user is signed in' do
      include_context 'sign in user'

      let!(:task) { create(:task, name: name, user: user) }

      it 'destroys task' do
        expect { delete :destroy, id: task.id }
          .to change { user.tasks.count }.by(-1)

        expect(response).to redirect_to(user_tasks_url)

        task = user.tasks.find_by(name: name)
        expect(task).to be nil
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      let!(:task) { create(:task, name: name) }
      let!(:task_user) { task.user }

      it 'destroys user task' do
        expect { delete :destroy, id: task.id }
          .to change { task_user.tasks.count }.by(-1)

        expect(response).to redirect_to(user_tasks_url)

        task = task_user.tasks.find_by(name: name)
        expect(task).to be nil
      end
    end
  end

  describe '#change_state' do
    context 'when user is signed in' do
      include_context 'sign in user'

      let!(:task) { create(:task, user: user) }

      it 'changes task state' do
        task_params = { state: 'started' }
        params = { id: task.id, task: task_params, format: :json }
        expect { post :change_state, params }
          .to change { task.reload.state }.from('new').to('started')
      end
    end

    context 'when admin is signed in' do
      include_context 'sign in admin'

      let!(:task) { create(:task, state: 'started') }

      it 'changes task state' do
        task_params = { state: 'finished' }
        params = { id: task.id, task: task_params, format: :json }
        expect { post :change_state, params }
          .to change { task.reload.state }.from('started').to('finished')
      end
    end
  end
end
