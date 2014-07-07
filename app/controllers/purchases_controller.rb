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
    @purchase = Purchase.find(purchase_params)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase }
    end
  end
  # GET /purchases/new
  def new
    @book = Book.find(params[:book_id])
    @purchase = @book.purchases.new
    @purchase.bookfiletype = params[:bookfiletype]
  end
  # GET /purchases/1/edit 29
  def edit
    @purchase = Purchase.find(params[:id])
  end
  # POST /purchases 34
  def create
    @purchase = Purchase.new(purchase_params)
    @book = Book.find(@purchase.book_id)
#    raise params.to_yaml
    @purchase.user_id = current_user.id

    if @purchase.save_with_payment
      redirect_to @purchase, :notice => "Thank you for purchasing this book!"
      if @purchase.bookfiletype == "pdf" && @book.bookpdf.present?
###TEMP STOP DOWNLOAD        redirect_to @book.bookpdf.to_s, :notice => "Thank you for purchasing " + @book.title + "!"

#        data = open("https://authorprofile.s3.amazonaws.com/book/14/bookpdf") #@book.bookpdf.to_s) 
#        send_data data.read, filename: "LisaSchaeferCV.docx", type: "application/pdf", disposition: 'attachment', stream: 'true', buffer_size: '4096' 
      end
      if @purchase.bookfiletype == "mobi" && @book.bookmobi.present?
###TEMP STOP DOWNLOAD        redirect_to @book.bookmobi.to_s, :notice => "Thank you for purchasing " + @book.title + "!"
      end
      if @purchase.bookfiletype == "epub" && @book.bookepub.present?
###TEMP STOP DOWNLOAD        redirect_to @book.bookepub.to_s, :notice => "Thank you for purchasing " + @book.title + "!"
      end
      if @purchase.bookfiletype == "kobo" && @book.bookkobo.present?
###TEMP STOP DOWNLOAD        redirect_to @book.bookkobo.to_s, :notice => "Thank you for purchasing " + @book.title + "!"
      end
    else
      redirect_to(:back, :notice => "Your order did not go through. Try again.")
    end
  end

  # PUT /purchases/1.json
  def update
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      if @purchase.update_attributes(params[:purchase])
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
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
      params.require(:purchase).permit(  :stripe_customer_token, :bookfiletype, :book_id, :stripe_card_token, :user_id)
    end

end
