class PurchasesController < ApplicationController
  # GET /purchases
  # GET /purchases.json
  def index
    @purchases = Purchase.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchases }
    end
  end

  # GET /purchases/1
  # GET /purchases/1.json 14
  def show
    @purchase = Purchase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchase }
    end
  end

  # GET /purchases/new
  # GET /purchases/new.json 25
  def new
    @book = Book.find(params[:book_id])
    @purchase = @book.purchases.new
  end

  # GET /purchases/1/edit 29
  def edit
    @purchase = Purchase.find(params[:id])
  end

  # POST /purchases 34
  # POST /purchases.json
  def create
    @purchase = Purchase.new(params[:purchase])
    @book = Book.find(@purchase.book_id)
#    raise params.to_yaml
    @purchase.user_id = current_user.id

    if @purchase.save_with_payment
      redirect_to @purchase, :notice => "Thank you for purchasing this book!"
      if @book.bookpdf.present?
@book.coverpic   #download book        @book.bookpdf   #download book
        print "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      end
      #send shipment info to author
    else
      redirect_to(:back, :notice => "Your order did not go through. Try again.")
    end
  end

  # PUT /purchases/1
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

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase = Purchase.find(params[:id])
    @purchase.destroy

    respond_to do |format|
      format.html { redirect_to purchases_url }
      format.json { head :ok }
    end
  end
end
