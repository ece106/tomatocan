class PurchasesController < ApplicationController
  #  before_action :authenticate_user!, only: [:new ]
    # GET /purchases/1
    def show
      @purchase = Purchase.find(params[:id])
      if (!@purchase.merchandise_id.nil?) #If this is a donation do not look for merchandise
        loot = Merchandise.find(@purchase.merchandise_id)
        @itemname = loot.name
        id = loot.user_id
        @user = User.find(id)
      end
        respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @purchase }
      end
    end
    # GET /purchases/new
    def new
      if(params[:pricesold].present?) # Donation being made
        @purchase = Purchase.new
      elsif(params[:merchandise_id].present?) #Purchase being made
        @merchandise = Merchandise.find(params[:merchandise_id])
        @purchase = @merchandise.purchases.new
      end
      if user_signed_in?
        if current_user.stripe_customer_token.present?
          customer = Stripe::Customer.retrieve(current_user.stripe_customer_token)
          sourceid = customer.default_source
          card = customer.sources.retrieve(sourceid)
          @last4 = card.last4
          @expmonth = card.exp_month
          @expyear = card.exp_year
        end
      end
    end
    # POST /purchases 
    def create
      @purchase = Purchase.new(purchase_params)
      if user_signed_in?
        puts "0" ############################
        @purchase.user_id = current_user.id
      end
      if @purchase.merchandise_id?
        puts "1" ########### print 1 if the purchase is a merchandise
        @merchandise = Merchandise.find(@purchase.merchandise_id)
        if @merchandise.audio.present? || @merchandise.graphic.present? || @merchandise.video.present? || @merchandise.merchpdf.present? || @merchandise.merchmobi.present? || @merchandise.merchepub.present? #Is this if statement really the way we want to code?
          puts "2" ############## print 2 if the merhandise is any of the above
          if @purchase.save_with_payment
            puts "3" ########### print 3 is the purchase is saved with payment = true (model)
            #audio
            if @merchandise.audio.present?
              filename = @merchandise.audio.to_s.split('/')
              filename = filename[filename.length-1]
              data = open("#{@merchandise.audio.to_s}")
              send_data data.read, filename: filename, disposition: 'attachment' 
            end 
            #graphic
            if @merchandise.graphic.present?
              filename = @merchandise.graphic.to_s.split('/')
              filename = filename[filename.length-1]
              data = open("#{@merchandise.graphic.to_s}")
              send_data data.read, filename: filename, disposition: 'attachment' 
            end
            #video
            if @merchandise.video.present?
              filename = @merchandise.video.to_s.split('/')
              filename = filename[filename.length-1]
              data = open("#{@merchandise.video.to_s}")
              send_data data.read, filename: filename, disposition: 'attachment' 
            end
            #pdf
            if @merchandise.merchpdf.present?
              filename = @merchandise.merchpdf.to_s.split('/')
              filename = filename[filename.length-1]
              data = open("#{@merchandise.merchpdf.to_s}") 
              send_data data.read, filename: filename, disposition: 'attachment'
            end
            #mobi
            if @merchandise.merchmobi.present?
              filename = @merchandise.merchmobi.to_s.split('/')
              filename = filename[filename.length-1]
              data = open("#{@merchandise.merchmobi.to_s}")
              send_data data.read, filename: filename, disposition: 'attachment' 
            end
            #epub
            if @merchandise.merchepub.present?
              filename = @merchandise.merchepub.to_s.split('/')
              filename = filename[filename.length-1]
              data = open("#{@merchandise.merchepub.to_s}") 
              send_data data.read, filename: filename, disposition: 'attachment' 
            end
          else
            puts "4" ################################################
            redirect_back fallback_location: request.referrer, :notice => "Your order did not go through. Try again."
          end
        else 
          puts "5" ################################################
          @purchase.author_id = User.find(@merchandise.user_id) 
          if user_signed_in?
            puts "6" ################################################
            @purchase.user_id = current_user.id
          end
          if @purchase.save_with_payment
            puts "7" ################################################
            seller = User.find(@merchandise.user_id)
            redirect_to user_profile_path(seller.permalink)
            flash[:success] = "You have successfully completed the purchase! Thank you for being a patron of " + seller.name
          else
            puts "8" ################################################
            redirect_back fallback_location: request.referrer, :notice => "Your order did not go through. Try again."
          end
        end
      else # Making a donation 
        puts "9" ################################################
        if user_signed_in?
          puts "10" ################################################
          @purchase.user_id = current_user.id
        end
        if @purchase.save_with_payment
          puts "11" ################################################
          # Route back to author profile after donation
          seller = User.find(purchase_params[:author_id])
          redirect_to user_profile_path(seller.permalink), :notice => "You successfully donated $" + purchase_params[:pricesold] + " . Thank you for being a donor of " + seller.name 
        else
          puts "12" ################################################
          redirect_back fallback_location: request.referrer, :notice => "Your order did not go through. Try again."
        end
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
  
      def purchase_params
        params.require(:purchase).permit( :stripe_customer_token, :bookfiletype, :groupcut, :shipaddress,
          :book_id, :stripe_card_token,:pricesold, :user_id, :author_id, :merchandise_id, :group_id, :email)
      end
  
  end