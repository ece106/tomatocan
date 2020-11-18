class Invite

    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming
  
    attr_accessor :phone_number, :country_code, :relationship, :preferred_name, :sender_id
  
    validates :phone_number, :presence => true
  
    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
  
    def persisted?
      false
    end
  
  end