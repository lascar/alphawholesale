class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = ['pascal.carrie@gmail.com']
  end
end
