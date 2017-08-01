feature 'Create Activity' do
  background do
    @user = create(:user)
  end
  include_context 'logged in user'

  context 'a business exists' do
    before do
      @business = create(:business, user: @user)
    end

    context 'an activity does not exist' do
      before do
        visit root_path
        click_link 'Manage Business'
        click_link 'Create Activity'
      end

      context 'all params are submitted' do
        scenario 'creates bowling' do
          allow_any_instance_of(Paperclip::Attachment).to receive(:save)
            .and_return(true)

          complete_activity_form
          expect(page).to have_content 'Successfully created activity'
          expect(page).to have_content 'Country Club Lanes'
          expect(Activity.count).to eq 1
          activity = Activity.first
          expect(activity.type).to eq 'Bowling'
          expect(activity.description).to eq 'Enjoy your activity with us'
          expect(activity.picture_file_name).to eq 'avatar.png'
          expect(page.current_path).to eq(business_activities_path(@business))
        end

        scenario 'creates laser tag' do
          allow_any_instance_of(Paperclip::Attachment).to receive(:save)
            .and_return(true)

          complete_activity_form(type: 'Laser tag')
          expect(page).to have_content 'Successfully created activity'
          expect(page).to have_content 'Country Club Lanes'
          expect(Activity.count).to eq 1
          activity = Activity.first
          expect(activity.type).to eq 'LaserTag'
          expect(activity.description).to eq 'Enjoy your activity with us'
          expect(activity.picture_file_name).to eq 'avatar.png'
          expect(page.current_path).to eq(business_activities_path(@business))
        end

        scenario 'creates escape room' do
          allow_any_instance_of(Paperclip::Attachment).to receive(:save)
            .and_return(true)

          complete_activity_form(type: 'Escape room')
          expect(page).to have_content 'Successfully created activity'
          expect(page).to have_content 'Country Club Lanes'
          expect(Activity.count).to eq 1
          activity = Activity.first
          expect(activity.type).to eq 'EscapeRoom'
          expect(activity.description).to eq 'Enjoy your activity with us'
          expect(activity.picture_file_name).to eq 'avatar.png'
          expect(page.current_path).to eq(business_activities_path(@business))
        end

        context 'end_time is equal start_time' do
          scenario 'creates 24-hour activity' do
            allow_any_instance_of(Paperclip::Attachment).to receive(:save)
              .and_return(true)

            complete_activity_form(
              start_time: '08:00',
              end_time: '08:00'
            )
            expect(page).to have_content 'Successfully created activity'
          end
        end
      end

      context 'the activity name is omitted' do
        scenario 'user sees the activity name is required' do
          complete_activity_form(name: '')
          expect(page).to have_content "can't be blank"
        end
      end

      context 'invalid picture formats' do
        scenario 'user sees image is invalid' do
          allow_any_instance_of(Paperclip::Attachment).to receive(:save)
            .and_return(false)

          complete_activity_form(
            picture: 'spec/support/fixtures/paperclip/avatar.txt'
          )
          expect(page).to have_content 'Uploaded file is not a valid image'
        end
      end

      context 'wrong end_time scheduling' do
        context 'end_time is scheduled before start_time' do
          scenario 'user sees end_time need to schedule after start_time' do
            complete_activity_form(
              start_time: '12:30',
              end_time: '08:00'
            )
            expect(page).to have_content 'must be after the start time'
          end
        end
      end
    end

    context 'an activity exist' do
      before do
        create(:bowling, business: @business)
        visit root_path
        click_link 'Manage Business'
        click_link 'Add activity'
      end

      context 'all params are submitted' do
        scenario 'user can add more activity' do
          allow_any_instance_of(Paperclip::Attachment).to receive(:save)
            .and_return(true)

          activity_name = 'Bowling Club'
          complete_activity_form(name: activity_name)
          expect(page).to have_content 'Successfully created activity'
          expect(page).to have_content activity_name
          expect(page.current_path).to eq(business_activities_path(@business))
        end
      end
    end
  end

  def complete_activity_form(overrides={})
    within '#new_activity' do
      select( overrides[:type] || 'Bowling', :from => 'activity_type')
      fill_in 'activity_name', with: overrides[:name] || 'Country Club Lanes'
      fill_in 'activity_start_time', with: overrides[:start_time] || '08:00'
      fill_in 'activity_end_time', with: overrides[:end_time] || '16:00'
      fill_in 'activity_description', with: overrides[:description] ||
        'Enjoy your activity with us'
      attach_file 'activity_picture', overrides[:picture] ||
        'spec/support/fixtures/paperclip/avatar.png'
      click_button 'Submit'
    end
  end
end
