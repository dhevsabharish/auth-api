class Admin::LibrariansController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def create
    @librarian = User.new(librarian_params)
    @librarian.role = :librarian
  
    if @librarian.save
      log_event('librarian_created', current_user.id, current_user.email, librarian_id: @librarian.id)
      render json: {
        status: 200,
        message: "Librarian created successfully",
        data: UserSerializer.new(@librarian).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      log_event('librarian_creation_failed', current_user.id, current_user.email, errors: @librarian.errors.full_messages)
      render json: {
        status: 422,
        message: "Failed to create librarian",
        errors: @librarian.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def index
    @librarians = User.librarians
    log_event('librarians_listing', current_user.id, current_user.email)

    render json: {
      status: 200,
      data: @librarians.map { |librarian| UserSerializer.new(librarian).serializable_hash[:data][:attributes] }
    }, status: :ok
  end

  def destroy
    @librarian = User.librarians.find(params[:id])
    if @librarian.destroy
      log_event('librarian_deleted', current_user.id, current_user.email, librarian_id: @librarian.id)

      render json: {
        status: 200,
        message: "Librarian deleted successfully"
      }, status: :ok
    else
      log_event('librarian_deletion_failed', current_user.id, current_user.email, errors: @librarian.errors.full_messages)

      render json: {
        status: 422,
        message: "Failed to delete librarian",
        errors: @librarian.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def librarian_params
    params.require(:user).permit(:email, :password)
  end

  def ensure_admin!
    unless current_user.admin?
      log_event('access_denied', current_user.id, current_user.email)

      render json: {
        status: 403,
        message: "Access denied. Admin privileges required."
      }, status: :forbidden
    end
  end

  def log_event(event, user_id, email, additional_data = {})
    logger_data = { event: event, user_id: user_id, email: email }.merge(additional_data)
    MongoLogger.create(logger_data)
  end
end