class User < ApplicationRecord
    validates :username, :session_token, presence: true
    validates :password_digest, presence: { message: 'Password can''t be blank'}, length: { minimum: 6, allow_nil: true }   
    validates :session_token, presence: true
    after_initialize :ensure_session_token

# Make sure that ensure_session_token gets called before_validation

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        return nil if user.nil?
        user.is_password?(password) ? user : nil
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def reset_session_token!
        self.session_token = self.class.generate_session_token
        self.save!
        self.session_token
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def password
        @password
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    private

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end

end
