class BooksController < ApplicationController
#  before_filter :signed_in_user
  before_filter :authenticate_user!

  def create
    @book = current_user.books.build(params[:book])
    if @book.save
      redirect_to user_path(current_user)
    else
      redirect_to edit_user_path(current_user), :notice => "....................................................................................................Your book was not saved. Check the required info."
    end
   end

  def edit
    @booklist = Book.find(params[:author_id])
    @book = Book.find(params[:id])
    @purchases = @book.purchases
    if @book.save
      redirect_to author_path(current_user)
    else
      redirect_to edit_author_path(current_user), :notice => "....................................................................................................Your book was not saved. Check the required info."
    end
   end

  def update
    @bklist = Book.find(params[:id])
      if @bklist.update_attributes(params[:book])
         redirect_to user_path(current_user)
      else
         redirect_to edit_user_path(current_user), :notice => "....................................................................................................Your book was not saved. Check the required info."
      end
  end

  # GET /books/1
  def show
        data = open("https://authorprofile.s3.amazonaws.com/book/14/bookpdf") #@book.bookpdf.to_s) 
        send_data data.read, filename: "LisaSchaeferCV.pdf", type: "application/pdf", disposition: 'inline', stream: 'true', buffer_size: '4096' 
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