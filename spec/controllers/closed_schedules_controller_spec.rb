describe ClosedSchedulesController do
  describe 'GET index' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'an activity exists' do
        before { @activity = create(:bowling, business: @business) }
        context 'user is logged in' do
          login_user
          context 'user is a business owner' do
            before do
              @business.update(user: @user)
              get :index, params: { activity_id: @activity.id }
            end
            it_behaves_like 'a successful request'
          end

          context 'user is not a business owner' do
            before { get :index, params: { activity_id: @activity.id } }
            it_behaves_like 'an unauthorized request'
          end
        end

        context 'user is not logged in' do
          before { get :index, params: { activity_id: @activity.id } }
          it_behaves_like 'it requires authentication'
        end
      end
    end
  end

  describe 'POST create' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'an activity exists' do
        before { @activity = create(:bowling, business: @business) }
        context 'user is logged in' do
          login_user
          context 'user is a business owner' do
            before { @business.update(user: @user) }
            it 'creates an activity' do
              post :create, params: closed_schedule_params(activity_id: @activity.id)

              expect(ClosedSchedule.count).to eq 1
              expect(ClosedSchedule.first.label).to eq 'holiday'
              expect(ClosedSchedule.first.closed_on.to_s).to eq '2016-11-07'
              expect(ClosedSchedule.first.closed_days).to eq []
              expect(ClosedSchedule.first.closed_all_day).to eq true
              expect(ClosedSchedule.first.closed_specific_day).to eq true
              expect(ClosedSchedule.first.closing_begins_at).to eq nil
              expect(ClosedSchedule.first.closing_ends_at).to eq nil
              expect(ClosedSchedule.first.closed_all_reservables).to eq true
              expect(ClosedSchedule.first.activity).to eq @activity
              expect(response).to redirect_to activity_closed_schedules_path(@activity)
            end
          end

          context 'user is not a business owner' do
            before do
              post :create, params: closed_schedule_params(activity_id: @activity.id)
            end
            it_behaves_like 'an unauthorized request'
          end
        end

        context 'user is not logged in' do
          before do
            post :create, params: closed_schedule_params(activity_id: @activity.id)
          end
          it_behaves_like 'it requires authentication'
        end
      end
    end

    def closed_schedule_params(overrides={})
      {
        activity_id: overrides[:activity_id],
        closed_schedule: {
          label: 'holiday',
          closed_on: '7 Nov 2016',
          closed_days: '',
          closed_all_day: true,
          closed_specific_day: true,
          closing_begins_at: '',
          closing_ends_at: '',
          closed_all_reservables: true,
          activity_id: overrides[:activity_id]
        }
      }
    end
  end

  describe 'DELETE destroy' do
    context 'a business exists' do
      before { @business = create(:business) }
      context 'an activity exists' do
        before { @activity = create(:bowling, business: @business) }
        context 'closing time exists' do
          before { @closing_time = create(:closed_schedule, activity: @activity) }
          context 'user is logged in' do
            login_user
            context 'user is a business owner' do
              before { @business.update(user: @user) }
              it 'deletes closing time' do
                delete :destroy, params: { id: @closing_time }
                expect(ClosedSchedule.count).to be_zero
              end
            end
            context 'user is not a business owner' do
              before { delete :destroy, params: { id: @closing_time } }
              it_behaves_like 'an unauthorized request'
            end
          end
          context 'user is not logged in' do
            before { delete :destroy, params: { id: @closing_time } }
            it_behaves_like 'it requires authentication'
          end
        end
      end
    end
  end

end
