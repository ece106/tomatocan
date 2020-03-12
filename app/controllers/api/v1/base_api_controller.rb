class Api::V1::BaseApiController < ApplicationController
    skip_before_action :verify_authenticity_token
    respond_to :json
    acts_as_token_authentication_handler_for User, fallback: :none
end