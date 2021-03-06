class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :plan
  has_one :profile
  
  attr_accessor :stripe_card_token
  def save_with_subscription
    if valid?
      customer = Stripe::Customer.create(description: email, plan: 'price_1KCVivEnhb7BqqkErCjjRjY2', card: stripe_card_token,
      payment_method: 'pm_card_visa',
      invoice_settings: {
        default_payment_method: 'pm_card_visa'
      }
    )
      self.stripe_customer_token = customer.id
      save!
    end
  end
end
