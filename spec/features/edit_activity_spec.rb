feature 'edit activity' do
  background do
    @user = create(:user)
    @business = create(:business, user: @user)
  end
  include_context 'logged in user'

  context 'an activity exist' do
    before do
      @activity = create(:bowling, business: @business)
      @reservable = create(:lane, activity: @activity)
    end

    context 'user can edit the activity' do
      scenario 'successfully edited activity ' do
        allow_any_instance_of(Paperclip::Attachment).to receive(:save)
          .and_return(true)

        visit root_path
        click_link 'Manage Business'
        expect(page).to have_content @activity.name
        click_link 'Edit'
        edit_activity_form(name: 'Super Bowling')

        expect(page).to have_content 'Successfully updated activity'
        expect(page).to have_content 'Super Bowling'
        activity = Activity.first
        expect(activity.description).to eq 'so much fun with us'
        expect(activity.picture_file_name).to eq 'avatar.png'
        expect(activity.lead_time).to eq 5
      end

      scenario 'unsuccessfully edited activity' do
        visit root_path
        click_link 'Manage Business'
        expect(page).to have_content @activity.name
        click_link 'Edit'
        edit_activity_form(name: '')

        expect(page).to have_content "can't be blank"
      end
    end
  end

  def edit_activity_form(overrides={})
    fill_in 'activity_name', with: overrides[:name] || 'Country Club Lanes'
    fill_in 'activity_start_time', with: overrides[:start_time] || '08:00'
    fill_in 'activity_end_time', with: overrides[:end_time] || '16:00'
    fill_in 'activity_description', with: overrides[:activity] || 'so much fun with us'
    fill_in 'activity_lead_time', with: overrides[:lead_time] || 5
    attach_file 'activity_picture', overrides[:picture] ||
      'spec/support/fixtures/paperclip/avatar.png'
    click_button 'Submit'
  end
end
