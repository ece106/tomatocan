# Preview all emails at http://localhost:3000/rails/mailers/purchase_mailer
class PurchaseMailerPreview < ActionMailer::Preview

def purchase_saved
    user = User.last
    merch = Merchandise.first_or_create
    purch = Purchase.new(user: user, merchandise: merch)
    PurchaseMailer.with(seller: User.first, user:user,purchase: purch,merchandise: merch).purchase_saved
  end
  def donation_saved
    user = User.last
    purch = Purchase.new(user: user)
    PurchaseMailer.with(seller: User.first, user:user,purchase:purch,).donation_saved
  end
  def purchase_received
    PurchaseMailer.with(seller: User.first, user: User.last, purchase: Purchase.first_or_create, merchandise: Merchandise.first_or_create).purchase_received
  end
  def donation_received
    PurchaseMailer.with(seller: User.first, user: User.last, purchase: Purchase.first_or_create).donation_received
  end

end
