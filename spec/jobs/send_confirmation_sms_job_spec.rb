describe SendConfirmationSmsJob do
  include ActiveJob::TestHelper

  it 'queues the job' do
    params = { description: 'Hello', phone_number: '+1234565550' }
    expect { SendConfirmationSmsJob.perform_later(params) }
      .to have_enqueued_job(described_class).with(params)
  end
end
