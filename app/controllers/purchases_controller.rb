class PurchasesController < ApplicationController
  # GET /purchases.json
  def index
    @purchases = Purchase.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchases }
    end
  end
  # GET /purchases/1
  def show
    @purchase = Purchase.find(params[:id])
    if @purchase.book_id.present?
      book = Book.find(@purchase.book_id) 
      @itemname = book.title
      id = book.user_id
    elsif @purchase.merchandise_id.present?
      loot = Merchandise.find(@purchase.merchandise_id) 
      @itemname = loot.name
      id = loot.user_id
    end  
    @user = User.find(id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase }
    end
  end
  # GET /purchases/new
  def new
    puts params[:merchandise_id]
    if params[:book_id].present?
      @book = Book.find(params[:book_id])
      @purchase = @book.purchases.new
      @purchase.bookfiletype = params[:bookfiletype]
    end  
    puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    if params[:merchandise_id].present?
      @merchandise = Merchandise.find(params[:merchandise_id])
      @purchase = @merchandise.purchases.new
      puts "bbbbbbbbbbbbbbbbbbb"
      puts @purchase
    end 
    if current_user.stripe_customer_token.present?
      customer = Stripe::Customer.retrieve(current_user.stripe_customer_token)
      sourceid = customer.default_source
      card = customer.sources.retrieve(sourceid)
      @last4 = card.last4
      @expmonth = card.exp_month
      @expyear = card.exp_year
    end
  end
  # GET /purchases/1/edit 
  def edit
    @purchase = Purchase.find(params[:id])
  end
  # POST /purchases 
  def create
    @purchase = Purchase.new(purchase_params)
    if @purchase.book_id?
      @book = Book.find(@purchase.book_id) 
#    raise params.to_yaml
      @purchase.user_id = current_user.id
      if @purchase.save_with_payment
        if @purchase.bookfiletype == "pdf" && @book.bookpdf.present?
          if Rails.env.development? || Rails.env.test?
            data = open(Rails.root + "public#{@book.bookpdf.to_s}") 
            send_data data.read, filename: @book.bookpdf, type: "application/pdf", disposition: 'attachment' 
          else
            data = open("https://authorprofile.s3.amazonaws.com#{@book.bookpdf.to_s}") 
            send_data data.read, filename: @book.bookpdf, type: "application/pdf", disposition: 'attachment' 
          end
        end
        if @purchase.bookfiletype == "mobi" && @book.bookmobi.present?
          data = open("https://authorprofile.s3.amazonaws.com#{@book.bookmobi.to_s}") 
          send_data data.read, filename: @book.bookmobi, type: "application/mobi", disposition: 'attachment', stream: 'true', buffer_size: '4096' 
        end
        if @purchase.bookfiletype == "epub" && @book.bookepub.present?
          data = open("https://authorprofile.s3.amazonaws.com#{@book.bookepub.to_s}") 
          send_data data.read, filename: @book.bookepub, type: "application/epub", disposition: 'attachment', stream: 'true', buffer_size: '4096' 
        end

      else
        redirect_back fallback_location: request.referrer, :notice => "Your order did not go through. Try again."
      end
    elsif @purchase.merchandise_id?
      @merchandise = Merchandise.find(@purchase.merchandise_id)
      author = User.find(@merchandise.user_id)
      @purchase.user_id = current_user.id
      if @purchase.save_with_payment
        redirect_to userswithmerch_path, :notice => "Thank you for being a patron of " + author.name 
      else
        redirect_back fallback_location: request.referrer, :notice => "Your order did not go through. Try again."
      end 
    end 
  end

  def update #is this ever used
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      if @purchase.update_attributes(purchase_params)
        format.html { redirect_to @purchase }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /purchases/1.json
  def destroy
    @purchase = Purchase.find(params[:id])
    @purchase.destroy

    respond_to do |format|
      format.html { redirect_to purchases_url }
      format.json { head :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def purchase_params
      params.require(:purchase).permit( :stripe_customer_token, :bookfiletype, :groupcut, :shipaddress,
        :book_id, :stripe_card_token, :user_id, :author_id, :merchandise_id, :group_id)
    end

end
