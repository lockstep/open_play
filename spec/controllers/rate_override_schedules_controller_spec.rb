describe RateOverrideSchedulesController do
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
              post :create, params: rate_override_schedule_params(activity_id: @activity.id)

              schedule = RateOverrideSchedule.first
              expect(RateOverrideSchedule.count).to eq 1
              expect(schedule.label).to eq 'black friday'
              expect(schedule.overridden_on.to_s).to eq '2016-11-07'
              expect(schedule.overridden_days).to eq []
              expect(schedule.overridden_all_day).to eq true
              expect(schedule.overridden_specific_day).to eq true
              expect(schedule.overriding_begins_at).to eq nil
              expect(schedule.overriding_ends_at).to eq nil
              expect(schedule.overridden_all_reservables).to eq true
              expect(schedule.price).to eq 10.0
              expect(schedule.per_person_price).to eq 15.0
              expect(schedule.activity).to eq @activity
              expect(response).to redirect_to activity_rate_override_schedules_path(@activity)
            end
          end

          context 'user is not a business owner' do
            before do
              post :create, params: rate_override_schedule_params(activity_id: @activity.id)
            end
            it_behaves_like 'an unauthorized request'
          end
        end

        context 'user is not logged in' do
          before do
            post :create, params: rate_override_schedule_params(activity_id: @activity.id)
          end
          it_behaves_like 'it requires authentication'
        end
      end
    end

    def rate_override_schedule_params(overrides={})
      {
        activity_id: overrides[:activity_id],
        rate_override_schedule: {
          label: 'black friday',
          overridden_on: '7 Nov 2016',
          overridden_days: '',
          overridden_all_day: true,
          overridden_specific_day: true,
          overriding_begins_at: '',
          overriding_ends_at: '',
          overridden_all_reservables: true,
          price: '10.0',
          per_person_price: '15.0',
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
        context 'A Rate override schedule exists' do
          before { @schedule = create(:rate_override_schedule, activity: @activity) }
          context 'user is logged in' do
            login_user
            context 'user is a business owner' do
              before { @business.update(user: @user) }
              it 'deletes a rate override schedule' do
                delete :destroy, params: { id: @schedule.id }
                expect(RateOverrideSchedule.count).to be_zero
              end
            end
            context 'user is not a business owner' do
              before { delete :destroy, params: { id: @schedule.id } }
              it_behaves_like 'an unauthorized request'
            end
          end
          context 'user is not logged in' do
            before { delete :destroy, params: { id: @schedule.id } }
            it_behaves_like 'it requires authentication'
          end
        end
      end
    end
  end
end
