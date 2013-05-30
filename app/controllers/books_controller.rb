class BooksController < ApplicationController
  before_filter :signed_in_user

  def buy
# no longer used
    @book = Book.find(params[:id])
#    @purchase = @book.purchases.build(params[:purchase])

#    @purchase = Purchase.new(params[:purchase])
#    @purchase = Purchase.new
    @purchase = @book.purchases.new
  end

  def create
    @book = current_user.books.build(params[:book])
    if @book.save
      redirect_to author_path(current_user)
    else
      redirect_to edit_author_path(current_user)
    end
   end

  def edit
    @booklist = Book.find(params[:author_id])
    @book = Book.find(params[:id])
    @purchases = @book.purchases
    if @book.save
      redirect_to author_path(current_user)
    else
      redirect_to edit_author_path(current_user)
    end
   end

#34
  def update
    @bklist = Book.find(params[:id])
      if @bklist.update_attributes(params[:book])
         redirect_to user_path(current_user)
      else
         redirect_to edit_user_path(current_user)
      end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
#    @purchases = @book.purchases

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end

  def destroy
  end

  def new
  end
end