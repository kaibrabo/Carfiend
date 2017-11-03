class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

    # Facebook Log in
    def self.new_with_session(params, session)
        super.tap do |user|
            if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
                user.email = data["email"] if user.email.blank?
            end
        end
    end

    def self.from_omniauth(auth)
        # Google Authentication
        data = auth.info
        user = User.where(email: data['email']).first

        unless user
            user = User.create(name: data['name'],
                email: data['email'],
                password: Devise.friendly_token[0,20]
            )
        end

        user
        #  end

        # Facebook Authentication
        where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
            user.email = auth.info.email
            user.password = Devise.friendly_token[0,20]
            user.name = auth.info.name   # assuming the user model has a name
            user.image = auth.info.image # assuming the user model has an image
            user.skip_confirmation!
        end
    end
end
