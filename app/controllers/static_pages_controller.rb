class StaticPagesController < ApplicationController
  def home
    userswithyoutube = User.where("LENGTH(youtube1) < 20 AND LENGTH(youtube1) > 4 ")
    usersvidorder = userswithyoutube.order('updated_at DESC')
    @users = usersvidorder.paginate(:page => params[:page], :per_page => 12)
  end

  def howwork
  end

  def monthly #Maybe this should go in static pages
    @user = current_user
  end
  def payeveryone #called from button on monthly page
    pay
    redirect_to root_path
  end

  private
    def pay
      #with stripe's transfer_schedule, this method is no longer necessary
      notpaid = Purchase.where("paid IS NULL")
      n = notpaid.group(:author_id)
      paymenthash = n.sum(:authorcut)

#     for each author
#       send each authors' total from CrowdPublishTV stripe/bank? acnt to each authors' bank acnt
#       put today's date in each purchase's Paid column
      booksales = monthsales.group(:book_id)
      counthash = booksales.count
      earningshash = booksales.sum(:authorcut)

      for authorid, sumcut in paymenthash
        author = User.find(authorid)
        account = Stripe::Account.retrieve(author.stripeid) #stripeid id author's stripe acnt number
#        account.deposit ?
      end
    end

end
