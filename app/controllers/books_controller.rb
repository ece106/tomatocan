class BooksController < ApplicationController
#  before_filter :signed_in_user
  before_filter :authenticate_user!

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to user_profile_path(current_user.permalink)
    else
      redirect_to user_edit_path(current_user.permalink), :notice => "....................................................................................................Your book was not saved. Check the required info (*) or filetypes."
    end
  end

  def edit
   # @booklist = Book.find(params[:author_id])
    @book = Book.find(params[:id])
    @purchases = @book.purchases
    if @book.save
      redirect_to user_profile_path(current_user.permalink)
    else
      redirect_to user_edit_path(current_user.permalink), :notice => "....................................................................................................Your book was not saved. Check the required info (*) or filetypes."
    end
  end

  def update
    @book = Book.find(params[:id])
      if @book.update_attributes(book_params)
         redirect_to user_profile_path(current_user.permalink)
      else
         redirect_to user_edit_path(current_user.permalink), :notice => "....................................................................................................Your book was not saved. Check the required info."
      end
  end

  # GET /books/1
  def show
    @book = Book.find(params[:id])
#    @purchases = @book.purchases

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
#send_file("https://authorprofile.s3.amazonaws.com/book/14/bookpdf/LisaSchaeferCV.docx", disposition: 'attachment')

#        data = open("https://authorprofile.s3.amazonaws.com/book/14/bookpdf") #@book.bookpdf.to_s) 
#        send_data data.read, filename: "LisaSchaeferCV.docx", type: "application/docx", disposition: 'attachment', stream: 'true', buffer_size: '4096' 
#redirect_to "https://authorprofile.s3.amazonaws.com/book/14/bookpdf/LisaSchaeferCV.docx"
  end

  def destroy
  end

  def new
  end


  private
    # Use callbacks to share common setup or constraints between actions.

    def book_params
      params.require(:book).permit( :bookpdf, :bookepub, :bookmobi, :bookkobo, :coverpicurl, :title, :blurb, :releasedate, :genre, :price, :fiftychar, :user_id, :coverpic)
    end
  
end