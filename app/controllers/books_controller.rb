class BooksController < ApplicationController
#  before_filter :signed_in_user
  before_filter :authenticate_user!

  def index # This will be a result of some filters
    @books = Book.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      if @book.youtube1.match(/youtube.com/) || @book.youtube1.match(/youtu.be/)
        youtube1parsed = parse_youtube @book.youtube1
        @book.update_attribute(:youtube1, youtube1parsed)
      end
      if @book.youtube2.match(/youtube.com/) || @book.youtube2.match(/youtu.be/)
        youtube2parsed = parse_youtube @book.youtube2
        @book.update_attribute(:youtube2, youtube2parsed)
      end
      redirect_to user_profile_path(current_user.permalink)
    else
      redirect_to user_edit_path(current_user.permalink), :notice => "Your book was not saved. Check the required info (*), filetypes, or character counts."
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      if @book.youtube1.match(/youtube.com/) || @book.youtube1.match(/youtu.be/)
        youtube1parsed = parse_youtube @book.youtube1
        @book.update_attribute(:youtube1, youtube1parsed)
      end
      if @book.youtube2.match(/youtube.com/) || @book.youtube2.match(/youtu.be/)
        youtube2parsed = parse_youtube @book.youtube2
        @book.update_attribute(:youtube2, youtube2parsed)
      end
      redirect_to user_profile_path(current_user.permalink)
    else
      redirect_to user_edit_path(current_user.permalink), :notice => "Your book was not saved. Check the required info (*), filetypes, or character counts."
    end
  end

  def show
    @book = Book.find(params[:id])
    @user = User.find(@book.user_id)
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

  def destroy # Put in something that assigns the book to CrowdPublishTV admin when a user wants to delete
  end


  private
    # Use callbacks to share common setup or constraints between actions.

    def book_params
      params.require(:book).permit( :bookaudio, :bookpdf, :bookepub, :bookmobi, :coverpicurl, :title, :blurb, :releasedate, :genre, :price, :fiftychar, :user_id, :coverpic, :youtube1, :youtube2, :bkvideodesc1, :bkvideodesc2)
    end

    def parse_youtube url
       regex = /(?:youtu.be\/|youtube.com\/watch\?v=|youtube.com\/embed\/|\/(?=p\/))([\w\/\-]+)/
       url.match(regex)[1]
    end
  
end