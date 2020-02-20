namespace :integral do
  namespace :scheduled do
    desc 'Runs audit sweeper'
    task audit_sweeper: :environment do
      Integral::Lighthouse::AuditSweeperJob.perform_now
    end
  end
end
