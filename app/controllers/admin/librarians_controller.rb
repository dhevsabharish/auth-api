# app/controllers/admin/librarians_controller.rb
class Admin::LibrariansController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin!
  
    def index
      @librarians = User.librarians
      render json: {
        status: 200,
        data: @librarians.map { |librarian| UserSerializer.new(librarian).serializable_hash[:data][:attributes] }
      }, status: :ok
    end
  
    def destroy
      @librarian = User.librarians.find(params[:id])
      if @librarian.destroy
        render json: {
          status: 200,
          message: "Librarian deleted successfully"
        }, status: :ok
      else
        render json: {
          status: 422,
          message: "Failed to delete librarian",
          errors: @librarian.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
  
    private
  
    def ensure_admin!
      unless current_user.admin?
        render json: {
          status: 403,
          message: "Access denied. Admin privileges required."
        }, status: :forbidden
      end
    end
  end