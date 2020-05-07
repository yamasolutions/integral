module Integral
  class DeviseMailer < Devise::Mailer
    layout 'integral/mailer'
    helper 'integral/mail'
  end
end
